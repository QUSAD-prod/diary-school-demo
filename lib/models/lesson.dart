import 'package:flutter/foundation.dart';

@immutable
class Subject {
  const Subject({required this.subjectId, required this.discipline});

  final int subjectId;
  final String discipline;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        subjectId: json['subject_id'] as int,
        discipline: json['discipline'] as String,
      );

  Map<String, dynamic> toJson() =>
      {'subject_id': subjectId, 'discipline': discipline};
}

@immutable
class Lesson {
  const Lesson({
    required this.lessonId,
    required this.classId,
    required this.weekOfDay,
    required this.index,
    required this.office,
    required this.timeBegin,
    required this.timeEnd,
    required this.subjectId,
    this.teacherId,
    required this.subject,
  });

  final int lessonId;
  final int classId;
  final int weekOfDay;
  final int index;
  final String office;
  final String timeBegin;
  final String timeEnd;
  final int subjectId;
  final int? teacherId;
  final Subject subject;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        lessonId: json['lesson_id'] as int,
        classId: json['class_id'] as int,
        weekOfDay: json['week_of_day'] as int,
        index: json['index'] as int,
        office: json['office'] as String,
        timeBegin: json['time_begin'] as String,
        timeEnd: json['time_end'] as String,
        subjectId: json['subject_id'] as int,
        teacherId: json['teacher_id'] as int?,
        subject: Subject.fromJson(json['subject'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'lesson_id': lessonId,
        'class_id': classId,
        'week_of_day': weekOfDay,
        'index': index,
        'office': office,
        'time_begin': timeBegin,
        'time_end': timeEnd,
        'subject_id': subjectId,
        'teacher_id': teacherId,
        'subject': subject.toJson(),
      };
}

@immutable
class Timetable {
  const Timetable({required this.weekOfDay, required this.lessons});

  final int weekOfDay;
  final List<Lesson> lessons;

  factory Timetable.fromJson(Map<String, dynamic> json) => Timetable(
        weekOfDay: json['week_of_day'] as int,
        lessons: [
          for (final e in json['lessons'] as List? ?? const [])
            Lesson.fromJson(e as Map<String, dynamic>),
        ],
      );

  Map<String, dynamic> toJson() => {
        'week_of_day': weekOfDay,
        'lessons': [for (final e in lessons) e.toJson()],
      };
}

/// Ответ `shedule-holliday/check-day`: учебный ли день.
@immutable
class CheckDay {
  const CheckDay({required this.date, this.holiday});

  final DateTime date;

  /// Название праздника или каникул; `null` — обычный учебный день.
  final String? holiday;
}
