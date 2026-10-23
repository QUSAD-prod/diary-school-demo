import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/components/header.dart';
import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/modal.dart';
import 'package:diary_app/components/panel_header.dart';
import 'package:diary_app/components/spinner.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/models/index.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:diary_app/views/root/SheduleWeek/Homework/CreateHomework.dart';
import 'package:diary_app/views/root/SheduleWeek/Homework/HomeworkCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Домашнее задание на урок: личное и общее для класса.
class SheduleModalHomework extends StatefulWidget {
  const SheduleModalHomework({super.key, required this.lesson, required this.date});

  final Lesson lesson;
  final DateTime date;

  @override
  State<SheduleModalHomework> createState() => _SheduleModalHomeworkState();
}

class _SheduleModalHomeworkState extends State<SheduleModalHomework> {
  HomeworksGet? _homeworks;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final homeworks =
          await context.read<DiaryApi>().getHomeworks(widget.date, widget.lesson);
      if (mounted) setState(() => _homeworks = homeworks);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _create() async {
    final homework = await Navigator.push<Homework>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateHomework(lesson: widget.lesson, date: widget.date),
      ),
    );
    final current = _homeworks;
    // Задание могли добавить на другую дату — тогда здесь оно не нужно
    if (homework == null || current == null || !mounted) return;
    if (homework.lessonId != widget.lesson.lessonId ||
        homework.date != formatShort(widget.date)) {
      return;
    }
    setState(() => _homeworks = HomeworksGet(
          myHomeworks: [...current.myHomeworks, homework],
          otherHomeworks: current.otherHomeworks,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final homeworks = _homeworks;
    return ModalPage(
      title: 'Домашнее задание',
      action: PanelHeaderButton(
        label: 'Добавить задание',
        onClick: _create,
        child: const CustomIcon('add_outline_28'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(vk.paddingHorizontal, 4, vk.paddingHorizontal, 0),
            child: Text(
              '${widget.lesson.subject.discipline} · ${formatDay(widget.date)}',
              style: vk.text.subhead.copyWith(color: vk.colors.textSecondary),
            ),
          ),
          const Header('Личное'),
          ..._section(context, homeworks?.myHomeworks, showAuthor: false),
          const Header('Общее'),
          ..._section(context, homeworks?.otherHomeworks, showAuthor: true),
        ],
      ),
    );
  }

  List<Widget> _section(
    BuildContext context,
    List<Homework>? items, {
    required bool showAuthor,
  }) {
    final vk = context.vk;
    if (items == null) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: _error == null
              ? const Center(child: Spinner())
              : _Message(_error!),
        ),
      ];
    }
    if (items.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 4),
          child: const _Message('Пока домашки нет'),
        ),
      ];
    }
    return [
      for (final homework in items)
        HomeworkCard(homework: homework, showAuthor: showAuthor),
    ];
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal),
      child: Text(text, style: vk.text.subhead.copyWith(color: vk.colors.textSecondary)),
    );
  }
}
