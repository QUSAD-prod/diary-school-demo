// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shedule_week.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SheduleWeek on _SheduleWeek, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(
    () => super.loading,
    name: '_SheduleWeek.loading',
  )).value;

  late final _$dateAtom = Atom(name: '_SheduleWeek.date', context: context);

  @override
  DateTime get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(DateTime value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  late final _$timetablesAtom = Atom(
    name: '_SheduleWeek.timetables',
    context: context,
  );

  @override
  List<Timetable> get timetables {
    _$timetablesAtom.reportRead();
    return super.timetables;
  }

  @override
  set timetables(List<Timetable> value) {
    _$timetablesAtom.reportWrite(value, super.timetables, () {
      super.timetables = value;
    });
  }

  late final _$errorAtom = Atom(name: '_SheduleWeek.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$loadTimetablesAsyncAction = AsyncAction(
    '_SheduleWeek.loadTimetables',
    context: context,
  );

  @override
  Future<void> loadTimetables() {
    return _$loadTimetablesAsyncAction.run(() => super.loadTimetables());
  }

  late final _$checkDayAsyncAction = AsyncAction(
    '_SheduleWeek.checkDay',
    context: context,
  );

  @override
  Future<void> checkDay(DateTime day) {
    return _$checkDayAsyncAction.run(() => super.checkDay(day));
  }

  late final _$_SheduleWeekActionController = ActionController(
    name: '_SheduleWeek',
    context: context,
  );

  @override
  void updateDate(DateTime value) {
    final _$actionInfo = _$_SheduleWeekActionController.startAction(
      name: '_SheduleWeek.updateDate',
    );
    try {
      return super.updateDate(value);
    } finally {
      _$_SheduleWeekActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_SheduleWeekActionController.startAction(
      name: '_SheduleWeek.reset',
    );
    try {
      return super.reset();
    } finally {
      _$_SheduleWeekActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
date: ${date},
timetables: ${timetables},
error: ${error},
loading: ${loading}
    ''';
  }
}
