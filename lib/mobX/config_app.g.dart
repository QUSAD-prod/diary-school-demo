// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Config on _Config, Store {
  Computed<bool>? _$loginComputed;

  @override
  bool get login => (_$loginComputed ??= Computed<bool>(
    () => super.login,
    name: '_Config.login',
  )).value;

  late final _$themeAtom = Atom(name: '_Config.theme', context: context);

  @override
  ThemeConfig get theme {
    _$themeAtom.reportRead();
    return super.theme;
  }

  @override
  set theme(ThemeConfig value) {
    _$themeAtom.reportWrite(value, super.theme, () {
      super.theme = value;
    });
  }

  late final _$authAtom = Atom(name: '_Config.auth', context: context);

  @override
  AuthData? get auth {
    _$authAtom.reportRead();
    return super.auth;
  }

  @override
  set auth(AuthData? value) {
    _$authAtom.reportWrite(value, super.auth, () {
      super.auth = value;
    });
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_Config.logout',
    context: context,
  );

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$_ConfigActionController = ActionController(
    name: '_Config',
    context: context,
  );

  @override
  void setTheme(ThemeConfig value) {
    final _$actionInfo = _$_ConfigActionController.startAction(
      name: '_Config.setTheme',
    );
    try {
      return super.setTheme(value);
    } finally {
      _$_ConfigActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAuth(AuthData value) {
    final _$actionInfo = _$_ConfigActionController.startAction(
      name: '_Config.setAuth',
    );
    try {
      return super.setAuth(value);
    } finally {
      _$_ConfigActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
theme: ${theme},
auth: ${auth},
login: ${login}
    ''';
  }
}
