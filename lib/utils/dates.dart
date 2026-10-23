import 'package:intl/intl.dart';

/// Источник текущего времени. Тесты и скриншоты подменяют его,
/// чтобы получать одинаковый результат в любой день.
DateTime Function() now = DateTime.now;

DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime today() => dateOnly(now());

String capitalize(String text) =>
    text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

final _dayMonth = DateFormat('d MMMM', 'ru_RU');
final _dayMonthYear = DateFormat('d MMMM y', 'ru_RU');
final _weekday = DateFormat('EEEE', 'ru_RU');
final _short = DateFormat('dd.MM.y', 'ru_RU');

/// «23 октября», а для другого года — «23 октября 2027».
String formatDay(DateTime date) =>
    (date.year == now().year ? _dayMonth : _dayMonthYear).format(date);

/// «Пятница».
String formatWeekday(DateTime date) => capitalize(_weekday.format(date));

/// «23.10.2026» — формат дат в API.
String formatShort(DateTime date) => _short.format(date);
