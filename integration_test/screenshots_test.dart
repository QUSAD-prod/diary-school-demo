// Скриншоты для сторов и сквозной тест демо-режима.
//
// flutter drive --driver=test_driver/integration_test.dart \
//   --target=integration_test/screenshots_test.dart -d "iPhone 17 Pro"
//
// Снимается слой Flutter, а не экран устройства, поэтому на снимках
// нет статус-бара, Dynamic Island и полоски «домой», а цвета — в sRGB.
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:diary_app/api/demo/demo_diary_api.dart';
import 'package:diary_app/main.dart';
import 'package:diary_app/storage.dart';
import 'package:diary_app/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('демо-режим: от входа до тёмной темы', (tester) async {
    // Среда, 21 октября 2026, идёт третий урок
    now = () => DateTime(2026, 10, 21, 10, 40);
    tester.testTextInput.register();
    final semantics = tester.ensureSemantics();

    await initializeDateFormatting('ru_RU');
    final storage = await Storage.open();
    await storage.clearSession();
    storage.theme = ThemeConfig.light;

    final root = GlobalKey();
    final shots = <String, String>{};
    Future<void> screenshot(String name) async {
      // pumpAndSettle не ждёт декодирования картинок — даём им время
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 400)));
      await tester.pumpAndSettle();
      final boundary = root.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final png = await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: tester.view.devicePixelRatio);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        return data!.buffer.asUint8List();
      });
      shots['${(shots.length + 1).toString().padLeft(2, '0')}_$name'] = base64Encode(png!);
    }

    Future<void> tap(Finder finder) async {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    await tester.pumpWidget(RepaintBoundary(
      key: root,
      child: DiaryApp(storage: storage, api: DemoDiaryApi(storage)),
    ));
    await screenshot('start');

    await tap(find.text('Войти'));
    await screenshot('login');

    await tap(find.text('Войти'));
    expect(find.text('Среда'), findsOneWidget);
    await screenshot('schedule');

    await tap(find.text('Литература'));
    expect(find.text('3-й урок'), findsOneWidget);
    await screenshot('lesson');
    await tap(find.bySemanticsLabel('Закрыть'));

    await tap(find.text('Д/з').first);
    expect(find.text('Тоби'), findsOneWidget);
    await tap(find.bySemanticsLabel('Добавить задание'));
    await tester.enterText(find.byType(TextField), '№ 245 и 247, повторить формулы');
    await screenshot('create_homework');

    await tap(find.bySemanticsLabel('Сохранить'));
    expect(find.text('№ 245 и 247, повторить формулы'), findsOneWidget);
    await screenshot('homework');
    await tap(find.bySemanticsLabel('Закрыть'));

    await tap(find.text('Сводка'));
    expect(find.text('Сейчас идёт · до 11:10 · каб. 214'), findsOneWidget);
    await screenshot('summary');

    await tap(find.text('Профиль'));
    await screenshot('profile');

    await tap(find.text('Тёмная'));
    await screenshot('profile_dark');

    await tap(find.text('Расписание'));
    await screenshot('schedule_dark');

    await tap(find.text('Сводка'));
    await screenshot('summary_dark');

    storage.theme = ThemeConfig.system;
    semantics.dispose();
    binding.reportData = {'screenshots': shots};
  });
}
