import 'package:diary_app/components/button.dart';
import 'package:diary_app/components/card.dart';
import 'package:diary_app/components/header.dart';
import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/modal.dart';
import 'package:diary_app/components/placeholder.dart';
import 'package:diary_app/components/spinner.dart';
import 'package:diary_app/components/tappable.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/mobX/shedule_week.dart';
import 'package:diary_app/models/index.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:diary_app/views/root/SheduleWeek/Homework/SheduleModalHomework.dart';
import 'package:diary_app/views/root/SheduleWeek/SheduleModalLessonInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Карточка одного дня расписания.
class SheduleCard extends StatefulWidget {
  const SheduleCard({super.key, required this.date});

  final DateTime date;

  @override
  State<SheduleCard> createState() => _SheduleCardState();
}

class _SheduleCardState extends State<SheduleCard> {
  late final SheduleWeek _store = context.read<SheduleWeek>();

  @override
  void initState() {
    super.initState();
    // Учебный ли день, проверяем, когда карточка появилась на экране
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _store.checkDay(widget.date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    // Карточка по высоте содержимого, но не выше экрана
    return LayoutBuilder(
      builder: (context, constraints) => Align(
        alignment: Alignment.topCenter,
        child: ShadowCard(
          margin: EdgeInsets.all(vk.paddingHorizontal),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight - vk.paddingHorizontal * 2,
            ),
            child: Observer(builder: (_) {
              final state = _store.stateOf(widget.date);
              return switch (state.type) {
                SheduleWeekTypeDay.weekends => const _DayPlaceholder(
                    icon: 'calendar_outline_56',
                    header: 'Выходной',
                    text: 'Отдохни в этот день',
                  ),
                SheduleWeekTypeDay.holliday => _DayPlaceholder(
                    icon: 'gift_outline_56',
                    header: state.holiday!,
                    text: 'Уроков нет — можно отдохнуть',
                  ),
                _ => _buildLessons(context, state),
              };
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildLessons(BuildContext context, DayState state) {
    final vk = context.vk;
    final lessons = _store.lessonsOn(widget.date);
    final Widget body;
    if (_store.loading) {
      body = const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: Spinner(size: SpinnerSize.l)),
      );
    } else if (_store.error != null) {
      body = _DayPlaceholder(
        icon: 'cloud_slash_outline_28',
        header: 'Не удалось загрузить',
        text: _store.error!,
        action: CustomButton(
          child: 'Повторить',
          mode: ModeCustomButton.secondary,
          onClick: _store.loadTimetables,
        ),
      );
    } else if (lessons.isEmpty) {
      body = const _DayPlaceholder(
        icon: 'calendar_outline_56',
        header: 'Уроков нет',
        text: 'В этот день расписание пустое',
      );
    } else {
      body = ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 4),
        itemCount: lessons.length,
        separatorBuilder: (_, _) => const Separator(),
        itemBuilder: (_, i) => _LessonCell(lesson: lessons[i], date: widget.date),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(vk.paddingHorizontal, 14, vk.paddingHorizontal - 4, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  formatWeekday(widget.date),
                  style: vk.text.title2.copyWith(
                    color: vk.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 28, child: Center(child: _status(context, state))),
            ],
          ),
        ),
        const Separator(padded: false),
        Flexible(child: body),
      ],
    );
  }

  Widget _status(BuildContext context, DayState state) => switch (state.type) {
        SheduleWeekTypeDay.load => const Spinner(size: SpinnerSize.s),
        SheduleWeekTypeDay.offline => Semantics(
            label: 'Нет связи, показано сохранённое расписание',
            child: CustomIcon('cloud_slash_outline_28', color: context.colors.iconSecondary),
          ),
        _ => const SizedBox.shrink(),
      };
}

class _LessonCell extends StatelessWidget {
  const _LessonCell({required this.lesson, required this.date});

  final Lesson lesson;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    return Tappable(
      onClick: () => showModalPage<void>(
        context,
        (_) => SheduleModalLessonInfo(lesson: lesson, date: date),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.timeBegin, style: vk.text.subhead.copyWith(color: c.textPrimary, fontWeight: FontWeight.w500)),
                  Text(lesson.timeEnd, style: vk.text.subhead.copyWith(color: c.textSecondary)),
                ],
              ),
            ),
            Container(
              width: 2,
              height: 36,
              margin: const EdgeInsets.only(left: 4, right: 12),
              decoration: BoxDecoration(
                color: c.accentBlue,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.subject.discipline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vk.text.headline1.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lesson.office,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vk.text.footnote.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CustomButton(
              child: 'Д/з',
              mode: ModeCustomButton.secondary,
              size: SizeCustomButton.s,
              onClick: () => showModalPage<void>(
                context,
                (_) => SheduleModalHomework(lesson: lesson, date: date),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayPlaceholder extends StatelessWidget {
  const _DayPlaceholder({
    required this.icon,
    required this.header,
    required this.text,
    this.action,
  });

  final String icon;
  final String header;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: CustomPlaceholder(
          icon: CustomIcon(icon, size: 56),
          header: header,
          action: action,
          child: text,
        ),
      ),
    );
  }
}
