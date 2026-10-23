import 'package:diary_app/api/diary_api.dart';
import 'package:diary_app/components/button.dart';
import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/modal.dart';
import 'package:diary_app/components/panel_header.dart';
import 'package:diary_app/components/placeholder.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/mobX/config_app.dart';
import 'package:diary_app/mobX/sign_up.dart';
import 'package:diary_app/models/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Последний шаг регистрации. Привязка соцсетей запланирована
/// на следующую версию, поэтому шаг информационный.
class SignUp3 extends StatefulWidget {
  const SignUp3({super.key});

  @override
  State<SignUp3> createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  bool _loading = false;

  Future<void> _signUp() async {
    final signUp = context.read<SignUp>();
    setState(() => _loading = true);
    try {
      final auth = await context.read<DiaryApi>().signUp(SignUpRequest(
            login: signUp.login,
            password: signUp.password,
            // Вход в региональный дневник через WebView убран вместе со старым бэкендом
            session: '',
            regionId: signUp.regionId,
          ));
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
      appBar: const PanelHeader(before: PanelHeaderBack(), title: Text('Привязка')),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: CustomPlaceholder(
                icon: CustomIcon('user_circle_outline_28', size: 56),
                header: 'Почти готово',
                child: 'Скоро к аккаунту можно будет привязать VK ID, '
                    'чтобы входить в одно касание',
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: EdgeInsets.all(vk.paddingHorizontal),
            child: CustomButton(
              child: 'Завершить регистрацию',
              size: SizeCustomButton.l,
              stretched: true,
              loading: _loading,
              onClick: _signUp,
            ),
          ),
        ],
      ),
    );
  }
}
