import 'package:diary_app/api/demo/demo_data.dart';
import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/models/index.dart';
import 'package:diary_app/storage.dart';
import 'package:diary_app/utils/dates.dart';

/// Офлайн-реализация API: отвечает так же, как сервер, но данные
/// генерируются локально, а добавленные задания хранятся на устройстве.
class DemoDiaryApi extends DiaryApi {
  DemoDiaryApi(this._storage, {this.latency = const Duration(milliseconds: 350)});

  final Storage _storage;

  /// Имитация сетевой задержки, чтобы были видны состояния загрузки.
  final Duration latency;


  @override
  bool get isDemo => true;

  Future<void> _delay() => Future.delayed(latency);

  AuthData _auth(String login) => AuthData(
        token: 'demo',
        user: FullUser(
          firstName: demoUser.firstName,
          lastName: demoUser.lastName,
          nickname: demoUser.nickname,
          userId: demoUser.userId,
          role: demoUser.role,
          classId: demoUser.classId,
          login: login.isEmpty ? demoUser.login : login,
          schoolId: demoUser.schoolId,
        ),
      );

  @override
  Future<AuthData> login(String login, String password) async {
    await _delay();
    _seedHomeworks();
    return _auth(login);
  }

  @override
  Future<void> checkLogin(String login) => _delay();

  @override
  Future<AuthData> signUp(SignUpRequest request) async {
    await _delay();
    _seedHomeworks();
    return _auth(request.login);
  }

  @override
  Future<List<Timetable>> getTimetables() async {
    await _delay();
    return demoTimetables;
  }

  @override
  Future<CheckDay> checkDay(DateTime date) async {
    await _delay();
    return CheckDay(date: date, holiday: holidayOn(date));
  }

  @override
  Future<HomeworksGet> getHomeworks(DateTime date, Lesson lesson) async {
    await _delay();
    final key = formatShort(date);
    return HomeworksGet(
      myHomeworks: [
        for (final homework in _storage.demoHomeworks)
          if (homework.date == key && homework.lessonId == lesson.lessonId)
            homework,
      ],
      otherHomeworks: sharedHomeworks(date, key, lesson),
    );
  }

  @override
  Future<Homework> addHomework({
    required DateTime date,
    required Lesson lesson,
    required String text,
    required bool isPublic,
  }) async {
    await _delay();
    final homework = _homework(date, lesson, text, isPublic);
    _storage.demoHomeworks = [..._storage.demoHomeworks, homework];
    return homework;
  }

  Homework _homework(DateTime date, Lesson lesson, String text, bool isPublic) {
    final id = DateTime.now().microsecondsSinceEpoch;
    final user = session?.user ?? demoUser;
    return Homework(
      homeworkId: id,
      authorId: user.userId,
      author: SmallUser(
        firstName: user.firstName,
        lastName: user.lastName,
        login: user.login,
        userId: user.userId,
        role: user.role,
      ),
      source: 'USER',
      isPublic: isPublic,
      date: formatShort(date),
      lessonId: lesson.lessonId,
      taskId: id,
      task: Task(taskId: id, text: text),
    );
  }

  /// Первое личное задание, чтобы раздел «Личное» не был пустым:
  /// напоминание на ближайшую геометрию.
  void _seedHomeworks() {
    if (_storage.demoHomeworks.isNotEmpty) return;
    final start = today();
    for (var i = 0; i < 14; i++) {
      final date = start.add(Duration(days: i));
      final lessons = demoTimetables[date.weekday - 1].lessons;
      for (final lesson in lessons) {
        if (lesson.subject.discipline == 'Геометрия') {
          _storage.demoHomeworks = [
            _homework(date, lesson, 'Не забыть циркуль и транспортир', false),
          ];
          return;
        }
      }
    }
  }
}
