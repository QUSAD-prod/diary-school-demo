import 'package:diary_app/components/panel_header.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/components/weekday_switch.dart';
import 'package:diary_app/mobX/shedule_week.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:diary_app/views/root/SheduleWeek/SheduleCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Расписание: листание по дням без конца в обе стороны.
class SheduleWeekView extends StatefulWidget {
  const SheduleWeekView({super.key});

  @override
  State<SheduleWeekView> createState() => _SheduleWeekViewState();
}

class _SheduleWeekViewState extends State<SheduleWeekView> {
  // Страница _origin соответствует дате _base
  static const _origin = 100000;
  late final SheduleWeek _store = context.read<SheduleWeek>();
  late final DateTime _base = _store.date;
  late final _controller = PageController(initialPage: _origin);

  DateTime _dateOf(int page) =>
      DateTime(_base.year, _base.month, _base.day + page - _origin);

  // Считаем в UTC, чтобы переход на летнее время не сбивал число дней
  int _pageOf(DateTime date) =>
      _origin +
      DateTime.utc(date.year, date.month, date.day)
          .difference(DateTime.utc(_base.year, _base.month, _base.day))
          .inDays;

  void _selectWeekday(int index) {
    final target = _store.date.add(Duration(days: index - (_store.date.weekday - 1)));
    final page = _pageOf(dateOnly(target));
    final current = _controller.page?.round() ?? _origin;
    if ((page - current).abs() == 1) {
      _controller.animateToPage(
        page,
        duration: const Duration(milliseconds: 250),
        curve: context.vk.easing,
      );
    } else {
      _controller.jumpToPage(page);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PanelHeader(title: Observer(builder: (_) => Text(formatDay(_store.date)))),
        Observer(
          builder: (_) => WeekDaySwitch(
            activeEl: _store.date.weekday - 1,
            onTap: _selectWeekday,
          ),
        ),
        Expanded(
          child: ColoredBox(
            color: context.colors.background,
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (page) => _store.updateDate(_dateOf(page)),
              itemBuilder: (_, page) => SheduleCard(date: _dateOf(page)),
            ),
          ),
        ),
      ],
    );
  }
}
