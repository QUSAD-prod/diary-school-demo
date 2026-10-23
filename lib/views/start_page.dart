import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/components/button.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final isDemo = context.read<DiaryApi>().isDemo;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      dark ? 'resource/images/logo_light.png' : 'resource/images/logo_dark.png',
                      width: 112,
                      height: 112,
                      semanticLabel: 'Где Дневник',
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Добро пожаловать!',
                      textAlign: TextAlign.center,
                      style: vk.text.title1.copyWith(color: c.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Расписание уроков и домашние задания\nвсего класса в одном месте',
                      textAlign: TextAlign.center,
                      style: vk.text.headline1.copyWith(
                        color: c.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                child: 'Войти',
                size: SizeCustomButton.l,
                stretched: true,
                onClick: () => Navigator.pushNamed(context, '/login'),
              ),
              const SizedBox(height: 12),
              CustomButton(
                child: 'Регистрация',
                mode: ModeCustomButton.secondary,
                size: SizeCustomButton.l,
                stretched: true,
                onClick: () => Navigator.pushNamed(context, '/sign_up_1'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  isDemo ? 'Демо-версия: данные хранятся только на устройстве' : '',
                  textAlign: TextAlign.center,
                  style: vk.text.footnote.copyWith(color: c.textTertiary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
