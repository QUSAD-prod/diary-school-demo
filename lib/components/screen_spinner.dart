import 'package:diary_app/components/spinner.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

/// VKUI ScreenSpinner: блокирующий индикатор поверх экрана.
class ScreenSpinner extends StatelessWidget {
  const ScreenSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Container(
      width: 88,
      height: 88,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: vk.colors.backgroundContrastThemed,
        borderRadius: BorderRadius.circular(vk.borderRadius),
        boxShadow: vk.colors.elevation3,
      ),
      child: const Spinner(size: SpinnerSize.xl),
    );
  }
}

/// Показывает [ScreenSpinner], пока выполняется [task].
Future<T> withScreenSpinner<T>(
  BuildContext context,
  Future<T> Function() task,
) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (_) => const PopScope(
      canPop: false,
      child: Center(child: ScreenSpinner()),
    ),
  );
  navigator.push(route);
  try {
    return await task();
  } finally {
    navigator.removeRoute(route);
  }
}
