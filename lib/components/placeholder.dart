import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

/// VKUI Placeholder: пустое состояние с иконкой, заголовком и действием.
class CustomPlaceholder extends StatelessWidget {
  const CustomPlaceholder({
    super.key,
    this.icon,
    this.header,
    this.child,
    this.action,
    this.padded = true,
  });

  final Widget? icon;
  final String? header;
  final String? child;
  final Widget? action;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final header = this.header;
    final child = this.child;
    return Padding(
      padding: padded
          ? const EdgeInsets.symmetric(vertical: 48, horizontal: 32)
          : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IconTheme(data: IconThemeData(color: c.iconSecondary), child: icon!),
            ),
          if (header != null)
            Text(
              header,
              textAlign: TextAlign.center,
              style: vk.text.title2.copyWith(color: c.textPrimary),
            ),
          if (child != null)
            Padding(
              padding: EdgeInsets.only(top: header == null ? 0 : 8),
              child: Text(
                child,
                textAlign: TextAlign.center,
                style: vk.text.headline1.copyWith(
                  color: c.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          if (action != null)
            Padding(padding: const EdgeInsets.only(top: 16), child: action),
        ],
      ),
    );
  }
}
