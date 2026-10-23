import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/models/index.dart';
import 'package:diary_app/storage.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:mobx/mobx.dart';

part 'shedule_week.g.dart';

class SheduleWeek = _SheduleWeek with _$SheduleWeek;

abstract class _SheduleWeek with Store {
  _SheduleWeek(this._api, this._storage);

  final DiaryApi _api;
  final Storage _storage;

  /// Выбранный день.
  @observable
  DateTime date = today();

  /// Расписание по дням недели: индекс = weekday - 1.
  @observable
  List<Timetable> timetables = const [];

  @observable
  String? error;

  /// Проверенные дни: учебный, праздник или нет связи.
  final days = ObservableMap<DateTime, DayState>();

  @computed
  bool get loading => timetables.isEmpty && error == null;

  List<Lesson> lessonsOn(DateTime day) =>
      timetables.isEmpty ? const [] : timetables[day.weekday - 1].lessons;

  DayState stateOf(DateTime day) => day.weekday >= DateTime.saturday
      ? const DayState(SheduleWeekTypeDay.weekends)
      : days[day] ?? const DayState(SheduleWeekTypeDay.load);

  @action
  void updateDate(DateTime value) {
    date = dateOnly(value);
  }

  /// Показывает расписание из кэша и обновляет его с сервера.
  @action
  Future<void> loadTimetables() async {
    error = null;
    if (timetables.isEmpty) timetables = _storage.timetables ?? const [];
    try {
      final fresh = await _api.getTimetables();
      timetables = fresh;
      _storage.timetables = fresh;
    } on ApiException catch (e) {
      if (timetables.isEmpty) error = e.message;
    }
  }

  @action
  Future<void> checkDay(DateTime day) async {
    final state = stateOf(day);
    if (state.type != SheduleWeekTypeDay.load &&
        state.type != SheduleWeekTypeDay.offline) {
      return;
    }
    days[day] = const DayState(SheduleWeekTypeDay.load);
    try {
      final result = await _api.checkDay(day);
      days[day] = result.holiday == null
          ? const DayState(SheduleWeekTypeDay.work)
          : DayState(SheduleWeekTypeDay.holliday, result.holiday);
    } on ApiException {
      days[day] = const DayState(SheduleWeekTypeDay.offline);
    }
  }

  @action
  void reset() {
    timetables = const [];
    days.clear();
    date = today();
  }
}

enum SheduleWeekTypeDay { work, weekends, holliday, load, offline }

class DayState {
  const DayState(this.type, [this.holiday]);

  final SheduleWeekTypeDay type;
  final String? holiday;
}
