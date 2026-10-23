import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/components/button.dart';
import 'package:diary_app/components/form_item.dart';
import 'package:diary_app/components/input.dart';
import 'package:diary_app/components/modal.dart';
import 'package:diary_app/components/panel_header.dart';
import 'package:diary_app/components/screen_spinner.dart';
import 'package:diary_app/components/simple_cell.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/mobX/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final _email = RegExp(r"^[\w.!#$%&'*+\-/=?^`{|}~]+@[\w-]+(\.[\w-]+)+$");

class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  final _login = TextEditingController();
  final _pass = TextEditingController();

  String? _loginError;
  ({int id, String name})? _region;

  bool get _valid =>
      _login.text.length >= 6 && _pass.text.length >= 4 && _region != null;

  @override
  void initState() {
    super.initState();
    _login.addListener(() => setState(() => _loginError = null));
    _pass.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _login.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _chooseRegion() {
    FocusScope.of(context).unfocus();
    showModalPage<void>(
      context,
      (context) => ModalPage(
        title: 'Выберите регион',
        child: Column(
          children: [
            for (final region in regions)
              SimpleCell(
                child: region.name,
                onClick: () {
                  setState(() => _region = region);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _next() async {
    FocusScope.of(context).unfocus();
    final login = _login.text.trim();
    if (!_email.hasMatch(login)) {
      setState(() => _loginError = 'Введите почту');
      return;
    }
    final api = context.read<DiaryApi>();
    try {
      await withScreenSpinner(context, () => api.checkLogin(login));
    } on ApiException catch (e) {
      setState(() => _loginError = e.message);
      return;
    }
    if (!mounted) return;
    context.read<SignUp>().setSignUp1(login, _pass.text, _region!.id);
    Navigator.pushNamed(context, '/sign_up_3');
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Scaffold(
      appBar: const PanelHeader(before: PanelHeaderBack(), title: Text('Регистрация')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                FormItem(
                  top: 'Почта',
                  bottom: _loginError,
                  status: _loginError == null ? FormItemStatus.def : FormItemStatus.error,
                  child: Input(
                    controller: _login,
                    placeholder: 'Введите почту',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                  ),
                ),
                FormItem(
                  top: 'Пароль',
                  bottom: 'Латинские буквы, цифры и символы _@#*%',
                  child: Input(
                    controller: _pass,
                    placeholder: 'Придумайте пароль',
                    isPass: true,
                    autofillHints: const [AutofillHints.newPassword],
                    onSubmit: (_) => _chooseRegion(),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18),
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_@#*%]')),
                    ],
                  ),
                ),
                FormItem(
                  top: 'Регион',
                  bottom: 'Отсюда бот будет забирать расписание и задания',
                  child: SelectMimicry(
                    value: _region?.name,
                    placeholder: 'Выберите регион',
                    onClick: _chooseRegion,
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            minimum: EdgeInsets.all(vk.paddingHorizontal),
            child: CustomButton(
              child: 'Далее',
              size: SizeCustomButton.l,
              stretched: true,
              disabled: !_valid,
              onClick: _next,
            ),
          ),
        ],
      ),
    );
  }
}
