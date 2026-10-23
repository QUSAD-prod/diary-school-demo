import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

enum FormItemStatus { def, error, valid }

/// VKUI FormItem: подпись сверху, поле, подсказка снизу.
/// Статус передаётся полю внутри, как каскад CSS в VKUI.
class FormItem extends StatelessWidget {
  const FormItem({
    super.key,
    required this.child,
    this.top,
    this.bottom,
    this.status = FormItemStatus.def,
  });

  final Widget child;
  final String? top;
  final String? bottom;
  final FormItemStatus status;

  static FormItemStatus statusOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_FormItemScope>()?.status ??
      FormItemStatus.def;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final top = this.top;
    final bottom = this.bottom;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: vk.paddingHorizontal,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (top != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 8),
              child: Text(top, style: vk.text.subhead.copyWith(color: c.textSubhead)),
            ),
          _FormItemScope(status: status, child: child),
          if (bottom != null && bottom.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                bottom,
                style: vk.text.subhead.copyWith(
                  color: switch (status) {
                    FormItemStatus.def => c.textSecondary,
                    FormItemStatus.error => c.textNegative,
                    FormItemStatus.valid => c.textPositive,
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FormItemScope extends InheritedWidget {
  const _FormItemScope({required this.status, required super.child});

  final FormItemStatus status;

  @override
  bool updateShouldNotify(_FormItemScope old) => old.status != status;
}

/// Оформление поля VKUI FormField для [TextField].
InputDecoration fieldDecoration(
  BuildContext context, {
  String? placeholder,
  Widget? after,
}) {
  final vk = context.vk;
  final c = vk.colors;
  final status = FormItem.statusOf(context);
  final radius = BorderRadius.circular(vk.borderRadius);
  final width = VKTheme.hairline(context);
  // gapPadding нужен только плавающей подписи, иначе M3 сдвигает текст на 4pt
  OutlineInputBorder border(Color color) => OutlineInputBorder(
        gapPadding: 0,
        borderRadius: radius,
        borderSide: BorderSide(color: color, width: width),
      );
  final statusColor = switch (status) {
    FormItemStatus.def => null,
    FormItemStatus.error => c.strokeNegative,
    FormItemStatus.valid => c.strokePositive,
  };
  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: status == FormItemStatus.error
        ? c.backgroundNegativeTint
        : c.fieldBackground,
    hintText: placeholder,
    hintStyle: vk.text.text.copyWith(color: c.textSecondary),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    enabledBorder: border(statusColor ?? c.fieldBorderAlpha),
    focusedBorder: border(statusColor ?? c.strokeAccent),
    suffixIcon: after,
    suffixIconColor: c.iconSecondary,
    suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
  );
}
