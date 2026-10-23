import 'package:mobx/mobx.dart';

part 'sign_up.g.dart';

/// Данные регистрации, которые собираются по шагам.
class SignUp = _SignUp with _$SignUp;

abstract class _SignUp with Store {
  @observable
  String login = '';

  @observable
  String password = '';

  @observable
  int regionId = 0;

  @action
  void setSignUp1(String login, String password, int regionId) {
    this.login = login;
    this.password = password;
    this.regionId = regionId;
  }
}
