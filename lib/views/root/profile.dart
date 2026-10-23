import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/components/avatar.dart';
import 'package:diary_app/components/header.dart';
import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/panel_header.dart';
import 'package:diary_app/components/simple_cell.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/components/weekday_switch.dart';
import 'package:diary_app/mobX/config_app.dart';
import 'package:diary_app/mobX/shedule_week.dart';
import 'package:diary_app/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<void> _logout(BuildContext context) async {
    final config = context.read<Config>();
    final store = context.read<SheduleWeek>();
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        final isIOS = context.vk.isIOS;
        Widget action(String label, bool value, {bool destructive = false}) => isIOS
            ? CupertinoDialogAction(
                isDestructiveAction: destructive,
                onPressed: () => Navigator.pop(context, value),
                child: Text(label),
              )
            : TextButton(
                onPressed: () => Navigator.pop(context, value),
                child: Text(label),
              );
        return AlertDialog.adaptive(
          title: const Text('Выход'),
          content: const Text('Задания, добавленные на этом устройстве, будут удалены.'),
          actions: [
            action('Отмена', false),
            action('Выйти', true, destructive: true),
          ],
        );
      },
    );
    if (confirmed != true) return;
    store.reset();
    await config.logout();
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final config = context.read<Config>();
    final isDemo = context.read<DiaryApi>().isDemo;
    return Column(
      children: [
        const PanelHeader(title: Text('Профиль')),
        Expanded(
          child: ColoredBox(
            color: c.background,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 8),
              children: [
                Group(
                  card: true,
                  first: true,
                  children: [
                    Observer(builder: (_) {
                      final user = config.auth?.user;
                      final name = user?.fullName ?? '';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Avatar(
                              size: 96,
                              initials: Avatar.initialsOf(name.isEmpty ? (user?.login ?? '?') : name),
                              gradient: user?.userId ?? 0,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              name.isEmpty ? (user?.nickname ?? '') : name,
                              style: vk.text.title2.copyWith(color: c.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.login ?? '',
                              style: vk.text.subhead.copyWith(color: c.textSecondary),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                Group(
                  card: true,
                  header: const Header('Оформление'),
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(vk.paddingHorizontal, 0, vk.paddingHorizontal, 8),
                      child: Observer(
                        builder: (_) => SegmentedControl<ThemeConfig>(
                          options: const {
                            ThemeConfig.system: 'Системная',
                            ThemeConfig.light: 'Светлая',
                            ThemeConfig.dark: 'Тёмная',
                          },
                          value: config.theme,
                          onChanged: config.setTheme,
                        ),
                      ),
                    ),
                  ],
                ),
                Group(
                  card: true,
                  children: [
                    if (isDemo)
                      const SimpleCell(
                        before: CustomIcon('info_circle_outline_28'),
                        child: 'Демо-режим',
                        subtitle: 'Сервер дневника закрыт, поэтому расписание '
                            'и задания генерируются на устройстве',
                        multiline: true,
                      ),
                    SimpleCell(
                      before: const CustomIcon('door_arrow_right_outline_28'),
                      child: 'Выйти',
                      color: c.textNegative,
                      onClick: () => _logout(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
