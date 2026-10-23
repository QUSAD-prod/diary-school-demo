import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/tappable.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

/// VKUI Checkbox: строка с иконкой-флажком и подписью.
class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.child,
    required this.value,
    required this.onChanged,
    this.description,
  });

  final String child;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final description = this.description;
    return Semantics(
      checked: value,
      child: Tappable(
        onClick: () => onChanged(!value),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 10),
          child: Row(
            children: [
              CustomIcon(
                value ? 'check_box_on_24' : 'check_box_off_24',
                color: value ? c.iconAccent : c.iconTertiary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(child, style: vk.text.text.copyWith(color: c.textPrimary)),
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          description,
                          style: vk.text.footnote.copyWith(color: c.textSecondary),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
