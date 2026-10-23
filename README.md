# Где Дневник

Школьное расписание и домашние задания всего класса. Flutter-приложение
для iOS, Android и web, оформленное по VKUI 8 (токены vkIOS / vkBase).

## Демо-режим

Бэкенд `api-diary-school.ru` больше не работает, поэтому по умолчанию
приложение собирается в демо-режиме (`DemoDiaryApi`):

- подходят любые логин и пароль (≥ 6 и ≥ 4 символов), на экране входа они уже подставлены;
- расписание 9 «Б» класса, задания бота «Тоби» и одноклассников генерируются
  детерминированно, государственные праздники отмечаются как выходные;
- добавленные задания и настройки хранятся только на устройстве (Hive).

Для настоящего сервера:

```sh
flutter run --dart-define=API_URL=https://example.com/
```

`RemoteDiaryApi` использует прежние эндпоинты (`user/login`, `lessons/get`,
`homeworks/get` и т.д.). Шаг регистрации с входом в региональный электронный
дневник через WebView удалён вместе со старым бэкендом.

## Разработка

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # MobX-сторы
flutter analyze && flutter test
```

- `lib/components/tokens.dart` — цвета, типографика и размеры из `@vkontakte/vkui-tokens`;
- `lib/components/` — компоненты по мотивам VKUI: Button, PanelHeader, Tabbar, FormItem, SimpleCell, ModalPage…;
- `resource/icons/` — иконки из `@vkontakte/icons`;
- `lib/api/` — интерфейс `DiaryApi`, демо и HTTP-реализации;
- иконки приложения генерируются из `resource/launcher/`: `dart run flutter_launcher_icons`.

## Скриншоты

Сквозной сценарий демо-режима снимает 11 экранов в светлой и тёмной теме.
Снимается слой Flutter, поэтому на картинках нет статус-бара и Dynamic Island,
размер равен разрешению устройства (iPhone 17 Pro — 1206 × 2622).

```sh
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshots_test.dart -d "iPhone 17 Pro"
```

Результат — `screenshots/ios/iphone-17-pro/`, другой каталог задаётся
переменной окружения `SCREENSHOTS_DIR`.
