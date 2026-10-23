import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/models/index.dart';
import 'package:diary_app/storage.dart';
import 'package:mobx/mobx.dart';

part 'config_app.g.dart';

class Config = _Config with _$Config;

abstract class _Config with Store {
  _Config(this._storage, this.api)
      : theme = _storage.theme,
        auth = _storage.auth {
    api.session = auth;
  }

  final Storage _storage;
  final DiaryApi api;

  @observable
  ThemeConfig theme;

  @observable
  AuthData? auth;

  @computed
  bool get login => auth != null;

  @action
  void setTheme(ThemeConfig value) {
    theme = value;
    _storage.theme = value;
  }

  @action
  void setAuth(AuthData value) {
    auth = value;
    api.session = value;
    _storage.auth = value;
  }

  @action
  Future<void> logout() async {
    auth = null;
    api.session = null;
    await _storage.clearSession();
  }
}
