import 'package:diary_app/components/button.dart';
import 'package:diary_app/components/header.dart';
import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/modal.dart';
import 'package:diary_app/components/simple_cell.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/models/index.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:diary_app/views/root/SheduleWeek/Homework/SheduleModalHomework.dart';
import 'package:flutter/material.dart';

/// Подробности урока.
class SheduleModalLessonInfo extends StatelessWidget {
  const SheduleModalLessonInfo({super.key, required this.lesson, required this.date});

  final Lesson lesson;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return ModalPage(
      title: lesson.subject.discipline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Group(
            children: [
              SimpleCell(
                before: const CustomIcon('clock_outline_28'),
                child: '${lesson.timeBegin} – ${lesson.timeEnd}',
                subtitle: '${lesson.index}-й урок',
              ),
              SimpleCell(
                before: const CustomIcon('place_outline_28'),
                child: lesson.office,
                subtitle: 'Кабинет',
              ),
              SimpleCell(
                before: const CustomIcon('calendar_outline_28'),
                child: formatDay(date),
                subtitle: formatWeekday(date),
              ),
            ],
          ),
          const Separator(),
          // Оценки и учитель пока не приходят из API
          const Group(
            header: Header('Оценки'),
            children: [_Empty()],
          ),
          const Separator(),
          const Group(
            header: Header('Учитель'),
            children: [_Empty()],
          ),
          Padding(
            padding: EdgeInsets.all(vk.paddingHorizontal),
            child: CustomButton(
              child: 'Домашнее задание',
              mode: ModeCustomButton.secondary,
              size: SizeCustomButton.l,
              stretched: true,
              onClick: () {
                // Контекст модалки после закрытия недействителен — открываем от навигатора
                final navigator = Navigator.of(context)..pop();
                showModalPage<void>(
                  navigator.context,
                  (_) => SheduleModalHomework(lesson: lesson, date: date),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 4),
      child: Text(
        'Здесь пока пусто',
        style: vk.text.subhead.copyWith(color: vk.colors.textSecondary),
      ),
    );
  }
}
