import 'dart:io';

import 'package:diary_app/api/demo/demo_data.dart';
import 'package:diary_app/api/demo/demo_diary_api.dart';
import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/components/avatar.dart';
import 'package:diary_app/models/index.dart';
import 'package:diary_app/storage.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  late Directory dir;
  late Storage storage;
  late DemoDiaryApi api;

  final wednesday = DateTime(2026, 10, 21);

  setUpAll(() => initializeDateFormatting('ru_RU'));

  setUp(() async {
    now = () => wednesday.add(const Duration(hours: 10, minutes: 40));
    dir = await Directory.systemTemp.createTemp('diary_test');
    storage = await Storage.open(path: dir.path);
    api = DemoDiaryApi(storage, latency: Duration.zero);
  });

  tearDown(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  test('неделя: пять учебных дней по шесть уроков', () async {
    final week = await api.getTimetables();
    expect(week, hasLength(7));
    expect([for (final day in week) day.lessons.length], [6, 6, 6, 6, 6, 0, 0]);
    expect(week[2].lessons[2].subject.discipline, 'Литература');
  });

  test('праздники приходят из check-day', () async {
    expect((await api.checkDay(DateTime(2026, 11, 4))).holiday, 'День народного единства');
    expect((await api.checkDay(wednesday)).holiday, isNull);
  });

  test('вход заводит личное задание на ближайшую геометрию', () async {
    final auth = await api.login('student@example.com', 'secret');
    expect(auth.user.login, 'student@example.com');
    expect(storage.demoHomeworks.single.task.text, contains('циркуль'));
  });

  test('добавленное задание сохраняется и попадает в «Личное»', () async {
    final lesson = demoTimetables[2].lessons.first;
    await api.addHomework(date: wednesday, lesson: lesson, text: '№ 1', isPublic: false);

    final again = DemoDiaryApi(storage, latency: Duration.zero);
    final homeworks = await again.getHomeworks(wednesday, lesson);
    expect(homeworks.myHomeworks.single.task.text, '№ 1');
    expect(homeworks.myHomeworks.single.isPublic, isFalse);
  });

  test('общие задания стабильны между запусками', () async {
    final lesson = demoTimetables[0].lessons[1];
    final first = await api.getHomeworks(wednesday, lesson);
    final second = await api.getHomeworks(wednesday, lesson);
    expect(first.otherHomeworks.first.isFromBot, isTrue);
    expect(
      [for (final h in first.otherHomeworks) h.task.text],
      [for (final h in second.otherHomeworks) h.task.text],
    );
  });

  test('выход стирает сессию, но не тему', () async {
    storage.auth = await api.login('a@b.ru', '1234');
    storage.theme = ThemeConfig.dark;
    await storage.clearSession();
    expect(storage.auth, isNull);
    expect(storage.demoHomeworks, isEmpty);
    expect(storage.theme, ThemeConfig.dark);
  });

  test('normalizeWeek дополняет неделю пустыми днями', () {
    final week = normalizeWeek([const Timetable(weekOfDay: 1, lessons: [])]);
    expect(week, hasLength(7));
    expect(week.last.weekOfDay, 7);
  });

  test('инициалы пропускают союзы', () {
    expect(Avatar.initialsOf('Вероятность и статистика'), 'ВС');
    expect(Avatar.initialsOf('Анна Смирнова'), 'АС');
    expect(Avatar.initialsOf('Ян Ли'), 'ЯЛ');
  });

  test('даты по-русски', () {
    expect(formatDay(wednesday), '21 октября');
    expect(formatDay(DateTime(2027, 1, 11)), '11 января 2027');
    expect(formatWeekday(wednesday), 'Среда');
    expect(formatShort(wednesday), '21.10.2026');
  });
}
