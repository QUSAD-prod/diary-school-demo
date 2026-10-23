import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/components/checkbox.dart';
import 'package:diary_app/components/form_item.dart';
import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/input.dart';
import 'package:diary_app/components/modal.dart';
import 'package:diary_app/components/panel_header.dart';
import 'package:diary_app/components/screen_spinner.dart';
import 'package:diary_app/components/simple_cell.dart';
import 'package:diary_app/mobX/shedule_week.dart';
import 'package:diary_app/models/index.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Урок, к которому можно привязать задание.
typedef _LessonDate = ({String header, DateTime date, Lesson lesson});

/// Новое задание. Возвращает созданный [Homework] через `Navigator.pop`.
class CreateHomework extends StatefulWidget {
  const CreateHomework({super.key, required this.lesson, required this.date});

  final Lesson lesson;
  final DateTime date;

  @override
  State<CreateHomework> createState() => _CreateHomeworkState();
}

class _CreateHomeworkState extends State<CreateHomework> {
  final _text = TextEditingController();
  late _LessonDate _target = (header: 'Этот урок', date: widget.date, lesson: widget.lesson);
  bool _isPublic = true;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  /// Этот урок и ещё до четырёх следующих уроков по тому же предмету.
  List<_LessonDate> _dates() {
    final store = context.read<SheduleWeek>();
    final subjectId = widget.lesson.subject.subjectId;
    final dates = <_LessonDate>[(header: 'Этот урок', date: widget.date, lesson: widget.lesson)];
    for (var i = 1; i < 30 && dates.length < 5; i++) {
      final date = widget.date.add(Duration(days: i));
      for (final lesson in store.lessonsOn(date)) {
        if (lesson.subject.subjectId != subjectId) continue;
        dates.add((
          header: dates.length == 1 ? 'Следующий урок' : formatWeekday(date),
          date: date,
          lesson: lesson,
        ));
        break;
      }
    }
    return dates;
  }

  void _chooseDate() {
    FocusScope.of(context).unfocus();
    showModalPage<void>(
      context,
      (context) => ModalPage(
        title: 'Выберите урок',
        child: Column(
          children: [
            for (final item in _dates())
              SimpleCell(
                child: item.header,
                subtitle: '${formatDay(item.date)}, ${item.lesson.timeBegin}',
                after: item.date == _target.date
                    ? const CustomIcon('done_outline_28')
                    : null,
                onClick: () {
                  setState(() => _target = item);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final text = _text.text.trim();
    if (text.isEmpty) {
      showSnackbar(context, 'Введите текст задания');
      return;
    }
    FocusScope.of(context).unfocus();
    final api = context.read<DiaryApi>();
    try {
      final homework = await withScreenSpinner(
        context,
        () => api.addHomework(
              date: _target.date,
              lesson: _target.lesson,
              text: text,
              isPublic: _isPublic,
            ),
      );
      // Новое задание сразу появится в списке, отдельное уведомление не нужно
      if (mounted) Navigator.pop(context, homework);
    } on ApiException catch (e) {
      if (mounted) showSnackbar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PanelHeader(
        before: const PanelHeaderBack(),
        title: const Text('Новое задание'),
        after: PanelHeaderButton(
          label: 'Сохранить',
          onClick: _submit,
          child: const CustomIcon('done_outline_28'),
        ),
      ),
      body: ListView(
        children: [
          FormItem(
            top: widget.lesson.subject.discipline,
            child: Textarea(controller: _text, placeholder: 'Например: № 312, 315'),
          ),
          FormItem(
            top: 'Урок',
            child: SelectMimicry(
              value: '${_target.header} · ${formatDay(_target.date)}',
              onClick: _chooseDate,
            ),
          ),
          CustomCheckbox(
            child: 'Показать классу',
            description: 'Задание появится у одноклассников в разделе «Общее»',
            value: _isPublic,
            onChanged: (value) => setState(() => _isPublic = value),
          ),
        ],
      ),
    );
  }
}
