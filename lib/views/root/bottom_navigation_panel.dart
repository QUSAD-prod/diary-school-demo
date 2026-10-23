import 'package:diary_app/components/tabbar.dart';
import 'package:diary_app/mobX/shedule_week.dart';
import 'package:diary_app/views/root/profile.dart';
import 'package:diary_app/views/root/SheduleWeek/SheduleWeek.dart';
import 'package:diary_app/views/root/summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, this.initialTab = 1});

  final int initialTab;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _currentIndex = widget.initialTab;

  static const _items = [
    TabbarItem(icon: 'newsfeed_outline_28', label: 'Сводка'),
    TabbarItem(icon: 'calendar_outline_28', label: 'Расписание'),
    TabbarItem(icon: 'user_circle_outline_28', label: 'Профиль'),
  ];

  @override
  void initState() {
    super.initState();
    // Расписание нужно и сводке, и расписанию — грузим один раз здесь
    context.read<SheduleWeek>().loadTimetables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SummaryView(onOpenSchedule: () => setState(() => _currentIndex = 1)),
          const SheduleWeekView(),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: Tabbar(
        items: _items,
        selected: _currentIndex,
        onChanged: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
