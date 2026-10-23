import 'dart:convert';

import 'package:diary_app/models/index.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

enum ThemeConfig { system, light, dark }

/// Локальное хранилище. Модели лежат в Hive как JSON-строки,
/// поэтому адаптеры и кодогенерация не нужны.
class Storage {
  Storage._(this._box);

  final Box<String> _box;

  /// [path] задают тесты, в приложении берётся каталог документов.
  static Future<Storage> open({String? path}) async {
    path == null ? await Hive.initFlutter() : Hive.init(path);
    // Бинарные боксы версии 1.0 (адаптеры hive 2) больше не читаются
    for (final legacy in const ['auth_data', 'lessons', 'shedule_week']) {
      if (await Hive.boxExists(legacy)) await Hive.deleteBoxFromDisk(legacy);
    }
    return Storage._(await Hive.openBox<String>('app'));
  }

  T? _read<T>(String key, T Function(Object? json) parse) {
    final raw = _box.get(key);
    return raw == null ? null : parse(jsonDecode(raw));
  }

  Future<void> _write(String key, Object? value) =>
      value == null ? _box.delete(key) : _box.put(key, jsonEncode(value));

  AuthData? get auth =>
      _read('auth', (json) => AuthData.fromJson(json as Map<String, dynamic>));

  set auth(AuthData? value) => _write('auth', value);

  List<Timetable>? get timetables => _read('timetables', (json) => [
        for (final e in json as List) Timetable.fromJson(e as Map<String, dynamic>),
      ]);

  set timetables(List<Timetable>? value) => _write('timetables', value);

  ThemeConfig get theme =>
      ThemeConfig.values.asNameMap()[_box.get('theme')] ?? ThemeConfig.system;

  set theme(ThemeConfig value) => _box.put('theme', value.name);

  /// Задания, добавленные в демо-режиме.
  List<Homework> get demoHomeworks =>
      _read('demo_homeworks', (json) => [
            for (final e in json as List)
              Homework.fromJson(e as Map<String, dynamic>),
          ]) ??
      const [];

  set demoHomeworks(List<Homework> value) => _write('demo_homeworks', value);

  /// Выход из аккаунта: всё, кроме настроек оформления.
  Future<void> clearSession() =>
      _box.deleteAll(const ['auth', 'timetables', 'demo_homeworks']);
}
