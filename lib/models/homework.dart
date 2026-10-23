import 'package:flutter/foundation.dart';

import 'user.dart';

@immutable
class Task {
  const Task({required this.taskId, required this.text});

  final int taskId;
  final String text;

  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(taskId: json['task_id'] as int, text: json['text'] as String);

  Map<String, dynamic> toJson() => {'task_id': taskId, 'text': text};
}

@immutable
class Homework {
  const Homework({
    required this.homeworkId,
    this.authorId,
    this.author,
    required this.source,
    required this.isPublic,
    required this.date,
    required this.lessonId,
    required this.taskId,
    required this.task,
  });

  /// Задание, которое бот выгрузил из электронного дневника.
  static const sourceBot = 'BOT';

  final int homeworkId;
  final int? authorId;
  final SmallUser? author;
  final String source;
  final bool isPublic;

  /// Дата в формате `dd.MM.yyyy`, как её отдаёт сервер.
  final String date;
  final int lessonId;
  final int taskId;
  final Task task;

  bool get isFromBot => source == sourceBot;

  factory Homework.fromJson(Map<String, dynamic> json) => Homework(
        homeworkId: json['homework_id'] as int,
        authorId: json['author_id'] as int?,
        author: json['author'] == null
            ? null
            : SmallUser.fromJson(json['author'] as Map<String, dynamic>),
        source: json['source'] as String,
        isPublic: json['isPublic'] as bool,
        date: json['date'] as String,
        lessonId: json['lesson_id'] as int,
        taskId: json['task_id'] as int,
        task: Task.fromJson(json['task'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'homework_id': homeworkId,
        'author_id': authorId,
        'author': author?.toJson(),
        'source': source,
        'isPublic': isPublic,
        'date': date,
        'lesson_id': lessonId,
        'task_id': taskId,
        'task': task.toJson(),
      };
}

@immutable
class HomeworksGet {
  const HomeworksGet({required this.myHomeworks, required this.otherHomeworks});

  final List<Homework> myHomeworks;
  final List<Homework> otherHomeworks;

  factory HomeworksGet.fromJson(Map<String, dynamic> json) => HomeworksGet(
        myHomeworks: _list(json['my_homeworks']),
        otherHomeworks: _list(json['other_homeworks']),
      );

  static List<Homework> _list(Object? json) => [
        for (final e in json as List? ?? const [])
          Homework.fromJson(e as Map<String, dynamic>),
      ];
}
