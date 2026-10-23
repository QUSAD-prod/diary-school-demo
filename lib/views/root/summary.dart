import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/components/avatar.dart';
import 'package:diary_app/components/button.dart';
import 'package:diary_app/components/header.dart';
import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/modal.dart';
import 'package:diary_app/components/panel_header.dart';
import 'package:diary_app/components/simple_cell.dart';
import 'package:diary_app/components/spinner.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/mobX/shedule_week.dart';
import 'package:diary_app/models/index.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:diary_app/views/root/SheduleWeek/Homework/SheduleModalHomework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

const _weekdayAccusative = [
  'понедельник', 'вторник', 'среду', 'четверг', 'пятницу', 'субботу', 'воскресенье',
];

String _lessonsCount(int n) {
  final mod10 = n % 10, mod100 = n % 100;
  final word = mod10 == 1 && mod100 != 11
      ? 'урок'
      : mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)
          ? 'урока'
          : 'уроков';
  return '$n $word';
}

DateTime _nextSchoolDay(DateTime from) {
  var day = from.add(const Duration(days: 1));
  while (day.weekday >= DateTime.saturday) {
    day = day.add(const Duration(days: 1));
  }
  return day;
}

/// Сводка: что сегодня и что задано на следующий учебный день.
class SummaryView extends StatefulWidget {
  const SummaryView({super.key, required this.onOpenSchedule});

  final VoidCallback onOpenSchedule;

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  late final SheduleWeek _store = context.read<SheduleWeek>();
  final DateTime _today = today();
  late final DateTime _nextDay = _nextSchoolDay(_today);

  /// Задание на каждый урок следующего дня (личное важнее общего).
  List<(Lesson, Homework)>? _homeworks;
  late final ReactionDisposer _disposeWhen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _store.checkDay(_today);
      _store.checkDay(_nextDay);
    });
    _disposeWhen = when((_) => _store.timetables.isNotEmpty, _loadHomeworks);
  }

  @override
  void dispose() {
    _disposeWhen();
    super.dispose();
  }

  Future<void> _loadHomeworks() async {
    final api = context.read<DiaryApi>();
    try {
      final results = await Future.wait([
        for (final lesson in _store.lessonsOn(_nextDay))
          api.getHomeworks(_nextDay, lesson).then((homeworks) => (lesson, homeworks)),
      ]);
      if (!mounted) return;
      setState(() => _homeworks = [
            for (final (lesson, homeworks) in results)
              if ([...homeworks.myHomeworks, ...homeworks.otherHomeworks.where((h) => h.isFromBot)]
                  case [final homework, ...])
                (lesson, homework),
          ]);
    } on ApiException {
      if (mounted) setState(() => _homeworks = const []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Column(
      children: [
        const PanelHeader(title: Text('Сводка')),
        Expanded(
          child: ColoredBox(
            color: vk.colors.background,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 8),
              children: [
                Group(
                  card: true,
                  first: true,
                  header: Header(
                    'Сегодня',
                    size: HeaderSize.l,
                    after: Text('${formatWeekday(_today)}, ${formatDay(_today)}'),
                  ),
                  children: [Observer(builder: (_) => _buildToday(context))],
                ),
                Group(
                  card: true,
                  header: Header(
                    'Задания на ${_weekdayAccusative[_nextDay.weekday - 1]}',
                    size: HeaderSize.l,
                    after: Text(formatDay(_nextDay)),
                  ),
                  children: _buildHomeworks(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToday(BuildContext context) {
    final vk = context.vk;
    final state = _store.stateOf(_today);
    if (state.type == SheduleWeekTypeDay.weekends ||
        state.type == SheduleWeekTypeDay.holliday) {
      return SimpleCell(
        before: const CustomIcon('calendar_outline_28'),
        child: state.holiday ?? 'Выходной',
        subtitle: 'Следующий учебный день — '
            '${formatWeekday(_nextDay).toLowerCase()}, ${formatDay(_nextDay)}',
        multiline: true,
      );
    }
    if (_store.loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Spinner()),
      );
    }
    final lessons = _store.lessonsOn(_today);
    if (lessons.isEmpty) {
      return const SimpleCell(
        before: CustomIcon('calendar_outline_28'),
        child: 'Уроков нет',
      );
    }

    final time = TimeOfDay.fromDateTime(now());
    final minutes = time.hour * 60 + time.minute;
    int parse(String hhmm) =>
        int.parse(hhmm.substring(0, 2)) * 60 + int.parse(hhmm.substring(3, 5));
    final current = lessons.where(
      (l) => parse(l.timeBegin) <= minutes && minutes < parse(l.timeEnd),
    );
    final next = lessons.where((l) => parse(l.timeBegin) > minutes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SimpleCell(
          before: const CustomIcon('education_outline_28'),
          child: _lessonsCount(lessons.length),
          subtitle: '${lessons.first.timeBegin} – ${lessons.last.timeEnd}',
        ),
        if (current.isNotEmpty)
          _lessonCell(current.first, 'Сейчас идёт · до ${current.first.timeEnd}')
        else if (next.isNotEmpty)
          _lessonCell(next.first, 'Следующий урок · в ${next.first.timeBegin}')
        else
          const SimpleCell(
            before: CustomIcon('done_outline_28'),
            child: 'Уроки закончились',
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(vk.paddingHorizontal, 8, vk.paddingHorizontal, 4),
          child: CustomButton(
            child: 'Открыть расписание',
            mode: ModeCustomButton.secondary,
            size: SizeCustomButton.m,
            stretched: true,
            onClick: widget.onOpenSchedule,
          ),
        ),
      ],
    );
  }

  Widget _lessonCell(Lesson lesson, String status) => SimpleCell(
        before: const CustomIcon('clock_outline_28'),
        child: lesson.subject.discipline,
        subtitle: '$status · ${lesson.office}',
        chevron: true,
        onClick: () => showModalPage<void>(
          context,
          (_) => SheduleModalHomework(lesson: lesson, date: _today),
        ),
      );

  List<Widget> _buildHomeworks(BuildContext context) {
    final vk = context.vk;
    final homeworks = _homeworks;
    if (homeworks == null) {
      return const [Padding(padding: EdgeInsets.all(16), child: Center(child: Spinner()))];
    }
    if (homeworks.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 8),
          child: Text(
            'Ничего не задано',
            style: vk.text.subhead.copyWith(color: vk.colors.textSecondary),
          ),
        ),
      ];
    }
    return [
      for (final (lesson, homework) in homeworks)
        SimpleCell(
          before: Avatar(
            size: 40,
            initials: Avatar.initialsOf(lesson.subject.discipline),
            gradient: lesson.subject.subjectId,
          ),
          child: lesson.subject.discipline,
          subtitle: homework.task.text,
          multiline: true,
          onClick: () => showModalPage<void>(
            context,
            (_) => SheduleModalHomework(lesson: lesson, date: _nextDay),
          ),
        ),
    ];
  }
}
