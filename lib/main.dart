import 'package:diary_app/api/demo/demo_diary_api.dart';
import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/api/remote_diary_api.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/mobX/config_app.dart';
import 'package:diary_app/mobX/shedule_week.dart';
import 'package:diary_app/mobX/sign_up.dart';
import 'package:diary_app/storage.dart';
import 'package:diary_app/views/authentication/login.dart';
import 'package:diary_app/views/authentication/sign_up/sign_up_1.dart';
import 'package:diary_app/views/authentication/sign_up/sign_up_3.dart';
import 'package:diary_app/views/root/bottom_navigation_panel.dart';
import 'package:diary_app/views/start_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

/// Адрес бэкенда. Пустой — демо-режим (сервер api-diary-school.ru закрыт).
const apiUrl = String.fromEnvironment('API_URL');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final (storage, _) = await (
    Storage.open(),
    initializeDateFormatting('ru_RU'),
  ).wait;
  final api = apiUrl.isEmpty ? DemoDiaryApi(storage) : RemoteDiaryApi(apiUrl);
  runApp(DiaryApp(storage: storage, api: api));
}

class DiaryApp extends StatelessWidget {
  const DiaryApp({super.key, required this.storage, required this.api});

  final Storage storage;
  final DiaryApi api;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DiaryApi>.value(value: api),
        Provider<Config>(create: (_) => Config(storage, api)),
        Provider<SignUp>(create: (_) => SignUp()),
        Provider<SheduleWeek>(create: (_) => SheduleWeek(api, storage)),
      ],
      child: Builder(
        builder: (context) {
          final config = context.read<Config>();
          return Observer(
            builder: (_) => MaterialApp(
              title: 'Где Дневник',
              debugShowCheckedModeBanner: false,
              theme: buildTheme(Brightness.light),
              darkTheme: buildTheme(Brightness.dark),
              themeMode: switch (config.theme) {
                ThemeConfig.system => ThemeMode.system,
                ThemeConfig.light => ThemeMode.light,
                ThemeConfig.dark => ThemeMode.dark,
              },
              locale: const Locale('ru'),
              supportedLocales: const [Locale('ru')],
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              builder: (context, child) => AnnotatedRegion(
                value: systemOverlayStyle(Theme.of(context).brightness),
                child: child!,
              ),
              routes: {
                '/': (_) => Observer(
                      builder: (_) =>
                          config.login ? const BottomNavigation() : const StartPage(),
                    ),
                '/login': (_) => const Login(),
                '/sign_up_1': (_) => const SignUp1(),
                '/sign_up_3': (_) => const SignUp3(),
              },
            ),
          );
        },
      ),
    );
  }
}

SystemUiOverlayStyle systemOverlayStyle(Brightness brightness) =>
    (brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    );

ThemeData buildTheme(Brightness brightness) {
  final vk = VKTheme.build(brightness, defaultTargetPlatform);
  final c = vk.colors;
  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: c.backgroundAccent,
      brightness: brightness,
      primary: c.backgroundAccent,
      surface: c.backgroundContent,
      onSurface: c.textPrimary,
      error: c.backgroundNegative,
    ),
    scaffoldBackgroundColor: c.backgroundContent,
    canvasColor: c.backgroundContent,
    // В VKUI нет ripple: нажатие подсвечивается фоном (см. Tappable)
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    textTheme: TextTheme(
      bodyLarge: vk.text.text.copyWith(color: c.textPrimary),
      bodyMedium: vk.text.text.copyWith(color: c.textPrimary),
      bodySmall: vk.text.footnote.copyWith(color: c.textSecondary),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: c.strokeAccent,
      selectionColor: c.backgroundAccent.withValues(alpha: 0.24),
      selectionHandleColor: c.backgroundAccent,
    ),
    extensions: [vk],
  );
}
