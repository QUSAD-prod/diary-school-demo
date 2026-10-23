import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:integration_test/integration_test_driver.dart';

/// Сохраняет скриншоты из integration_test/screenshots_test.dart.
/// Каталог задаётся переменной SCREENSHOTS_DIR.
Future<void> main() => integrationDriver(
      responseDataCallback: (data) async {
        final dir = Platform.environment['SCREENSHOTS_DIR'] ?? 'screenshots/ios/iphone-17-pro';
        final shots = (data?['screenshots'] as Map?)?.cast<String, String>() ?? {};
        for (final MapEntry(key: name, value: png) in shots.entries) {
          // Сторы не любят альфа-канал в скриншотах — сохраняем RGB
          final image = img.decodePng(base64Decode(png))!.convert(numChannels: 3);
          final file = File('$dir/$name.png');
          await file.create(recursive: true);
          await file.writeAsBytes(img.encodePng(image));
        }
      },
    );
