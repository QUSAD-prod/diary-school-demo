import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/models/index.dart';
import 'package:dio/dio.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:intl/intl.dart';

/// Клиент бэкенда api-diary-school.ru: все методы — POST с ответом
/// вида `{"success": bool, "msg": ...}`.
class RemoteDiaryApi extends DiaryApi {
  RemoteDiaryApi(String baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
        ));

  final Dio _dio;

  @override
  bool get isDemo => false;

  Future<Map<String, dynamic>> _post(
    String path, {
    Map<String, dynamic> body = const {},
    bool auth = false,
  }) async {
    final user = session?.user;
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: {
        if (auth && user != null) ...{
          'token': session!.token,
          'payload': {'user_id': user.userId, 'role': user.role},
        },
        ...body,
      });
      return response.data!;
    } on DioException {
      throw ApiException.connection;
    }
  }

  /// Возвращает `msg` успешного ответа или бросает [ApiException].
  Future<T> _request<T>(
    String path, {
    Map<String, dynamic> body = const {},
    bool auth = false,
  }) async {
    final json = await _post(path, body: body, auth: auth);
    if (json['success'] != true) {
      throw ApiException(json['msg']?.toString() ?? 'Ошибка сервера');
    }
    return json['msg'] as T;
  }

  @override
  Future<AuthData> login(String login, String password) async {
    final msg = await _request<List>('user/login', body: {
      'type': 'DEFAULT',
      'login': login,
      'password': password,
    });
    if (msg.isEmpty) throw const ApiException('Неверный логин или пароль');
    return AuthData.fromJson(msg.first as Map<String, dynamic>);
  }

  @override
  Future<void> checkLogin(String login) async {
    final msg = await _request<Object?>('user/check-login', body: {'login': login});
    if (msg != 'ok') throw ApiException(msg.toString());
  }

  @override
  Future<AuthData> signUp(SignUpRequest request) async {
    final msg = await _request<Map<String, dynamic>>(
      'user/sign_up',
      body: request.toJson(),
    );
    return AuthData.fromJson(msg);
  }

  @override
  Future<List<Timetable>> getTimetables() async {
    List<Timetable> parse(List msg) => [
          for (final e in msg) Timetable.fromJson(e as Map<String, dynamic>),
        ];

    var timetables = parse(await _request<List>('lessons/get', auth: true));
    if (timetables.every((t) => t.lessons.isEmpty)) {
      // Расписание ещё не выгружено из электронного дневника — просим сервер найти его
      timetables = parse(await _request<List>(
        'lessons/search-lessons',
        body: {'date': DateFormat('y-MM-dd').format(now())},
        auth: true,
      ));
    }
    return normalizeWeek(timetables);
  }

  @override
  Future<CheckDay> checkDay(DateTime date) async {
    final json = await _post(
      'shedule-holliday/check-day',
      body: {'date': date.toString()},
      auth: true,
    );
    if (json['success'] == true) return CheckDay(date: date);
    final msg = json['msg'];
    final name = msg is Map ? msg['name'] as String? : null;
    return CheckDay(date: date, holiday: name ?? 'Каникулы');
  }

  @override
  Future<HomeworksGet> getHomeworks(DateTime date, Lesson lesson) async {
    final msg = await _request<Map<String, dynamic>>(
      'homeworks/get',
      body: {'date': formatShort(date), 'lesson_id': lesson.lessonId},
      auth: true,
    );
    return HomeworksGet.fromJson(msg);
  }

  @override
  Future<Homework> addHomework({
    required DateTime date,
    required Lesson lesson,
    required String text,
    required bool isPublic,
  }) async {
    final msg = await _request<Map<String, dynamic>>(
      'homework/add',
      body: {
        'date': formatShort(date),
        'text': text,
        'lesson_id': lesson.lessonId,
        'isPublic': isPublic,
      },
      auth: true,
    );
    return Homework.fromJson(msg);
  }
}
