// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUp on _SignUp, Store {
  late final _$loginAtom = Atom(name: '_SignUp.login', context: context);

  @override
  String get login {
    _$loginAtom.reportRead();
    return super.login;
  }

  @override
  set login(String value) {
    _$loginAtom.reportWrite(value, super.login, () {
      super.login = value;
    });
  }

  late final _$passwordAtom = Atom(name: '_SignUp.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$regionIdAtom = Atom(name: '_SignUp.regionId', context: context);

  @override
  int get regionId {
    _$regionIdAtom.reportRead();
    return super.regionId;
  }

  @override
  set regionId(int value) {
    _$regionIdAtom.reportWrite(value, super.regionId, () {
      super.regionId = value;
    });
  }

  late final _$_SignUpActionController = ActionController(
    name: '_SignUp',
    context: context,
  );

  @override
  void setSignUp1(String login, String password, int regionId) {
    final _$actionInfo = _$_SignUpActionController.startAction(
      name: '_SignUp.setSignUp1',
    );
    try {
      return super.setSignUp1(login, password, regionId);
    } finally {
      _$_SignUpActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
login: ${login},
password: ${password},
regionId: ${regionId}
    ''';
  }
}
