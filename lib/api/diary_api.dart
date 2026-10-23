import 'package:diary_app/models/index.dart';

/// Источник данных дневника.
///
/// Бэкенд api-diary-school.ru больше не работает, поэтому по умолчанию
/// приложение собирается с `DemoDiaryApi`. Настоящий сервер подключается
/// флагом `--dart-define=API_URL=https://...`.
abstract class DiaryApi {
  /// Текущая сессия, ею подписываются запросы, которым нужна авторизация.
  AuthData? session;

  bool get isDemo;

  Future<AuthData> login(String login, String password);

  /// Бросает [ApiException] с текстом ошибки, если логин занят.
  Future<void> checkLogin(String login);

  Future<AuthData> signUp(SignUpRequest request);

  /// Расписание на неделю: семь элементов, с понедельника по воскресенье.
  Future<List<Timetable>> getTimetables();

  Future<CheckDay> checkDay(DateTime date);

  Future<HomeworksGet> getHomeworks(DateTime date, Lesson lesson);

  Future<Homework> addHomework({
    required DateTime date,
    required Lesson lesson,
    required String text,
    required bool isPublic,
  });
}

class ApiException implements Exception {
  const ApiException(this.message, {this.offline = false});

  static const connection = ApiException(
    'Нет соединения с сервером',
    offline: true,
  );

  final String message;

  /// Сервер недоступен: показываем закэшированные данные.
  final bool offline;

  @override
  String toString() => message;
}

/// Регионы с электронными дневниками, к которым умеет подключаться бот.
const regions = [(id: 1, name: 'Рязанская область')];

/// Приводит ответ сервера к семи дням недели (индекс = weekday - 1).
List<Timetable> normalizeWeek(List<Timetable> timetables) => [
      for (var i = 0; i < 7; i++)
        i < timetables.length
            ? timetables[i]
            : Timetable(weekOfDay: i + 1, lessons: const []),
    ];
