import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/components/button.dart';
import 'package:diary_app/components/card.dart';
import 'package:diary_app/components/form_item.dart';
import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/input.dart';
import 'package:diary_app/components/modal.dart';
import 'package:diary_app/components/panel_header.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/mobX/config_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final DiaryApi _api = context.read<DiaryApi>();
  // В демо-режиме подставляем данные, чтобы войти в одно касание
  late final _login = TextEditingController(text: _api.isDemo ? 'demo@diary-school.ru' : '');
  late final _pass = TextEditingController(text: _api.isDemo ? 'demo1234' : '');

  bool _loading = false;

  bool get _valid => _login.text.length >= 6 && _pass.text.length >= 4;

  @override
  void initState() {
    super.initState();
    _login.addListener(_rebuild);
    _pass.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _login.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_valid || _loading) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      final auth = await _api.login(_login.text.trim(), _pass.text);
      if (!mounted) return;
      context.read<Config>().setAuth(auth);
      Navigator.popUntil(context, (route) => route.isFirst);
    } on ApiException catch (e) {
      if (mounted) showSnackbar(context, e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Scaffold(
      appBar: const PanelHeader(before: PanelHeaderBack(), title: Text('Вход')),
      body: AutofillGroup(
        child: ListView(
          children: [
            if (_api.isDemo)
              const CustomBanner(
                before: CustomIcon('info_circle_outline_28'),
                header: 'Демо-режим',
                child: 'Подойдут любые логин и пароль. Расписание и задания '
                    'хранятся только на этом устройстве.',
              ),
            FormItem(
              top: 'Логин',
              child: Input(
                controller: _login,
                placeholder: 'Введите логин',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
              ),
            ),
            FormItem(
              top: 'Пароль',
              child: Input(
                controller: _pass,
                placeholder: 'Введите пароль',
                isPass: true,
                autofillHints: const [AutofillHints.password],
                onSubmit: (_) => _submit(),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_@#]')),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 12),
              child: CustomButton(
                child: 'Войти',
                appearance: AppearanceCustomButton.positive,
                size: SizeCustomButton.l,
                stretched: true,
                disabled: !_valid,
                loading: _loading,
                onClick: _submit,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'или',
                textAlign: TextAlign.center,
                style: vk.text.subhead.copyWith(color: vk.colors.textSecondary),
              ),
            ),
            for (final provider in const ['Войти через Google', 'Войти через VK ID'])
              Padding(
                padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 6),
                child: CustomButton(
                  child: provider,
                  mode: ModeCustomButton.outline,
                  size: SizeCustomButton.l,
                  stretched: true,
                  disabled: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
