import 'package:diary_app/components/spinner.dart';
import 'package:diary_app/components/tappable.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

enum SizeCustomButton { s, m, l }

enum ModeCustomButton { primary, secondary, tertiary, outline, link }

/// Цветовая схема кнопки. Бывший mode="commerce" теперь
/// `mode: primary, appearance: positive`, как в VKUI 5+.
enum AppearanceCustomButton { accent, positive, negative, neutral }

/// VKUI Button.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.child,
    this.onClick,
    this.mode = ModeCustomButton.primary,
    this.appearance = AppearanceCustomButton.accent,
    this.size = SizeCustomButton.m,
    this.stretched = false,
    this.loading = false,
    this.disabled = false,
    this.before,
  });

  final String child;
  final VoidCallback? onClick;
  final ModeCustomButton mode;
  final AppearanceCustomButton appearance;
  final SizeCustomButton size;
  final bool stretched;
  final bool loading;
  final bool disabled;
  final Widget? before;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final primary = mode == ModeCustomButton.primary;

    final background = switch (mode) {
      ModeCustomButton.primary => switch (appearance) {
          AppearanceCustomButton.accent => c.backgroundAccentThemed,
          AppearanceCustomButton.positive => c.backgroundPositive,
          AppearanceCustomButton.negative => c.backgroundNegative,
          AppearanceCustomButton.neutral => c.backgroundContentInverse,
        },
      ModeCustomButton.secondary => c.backgroundSecondaryAlpha,
      _ => Colors.transparent,
    };
    final foreground = primary
        ? switch (appearance) {
            AppearanceCustomButton.accent ||
            AppearanceCustomButton.neutral =>
              c.textContrastThemed,
            _ => c.textContrast,
          }
        : switch (appearance) {
            AppearanceCustomButton.accent => c.textAccentThemed,
            AppearanceCustomButton.positive => c.textPositive,
            AppearanceCustomButton.negative => c.textNegative,
            AppearanceCustomButton.neutral => c.textPrimary,
          };
    final border = mode == ModeCustomButton.outline
        ? Border.all(color: switch (appearance) {
            AppearanceCustomButton.accent => c.strokeAccentThemed,
            AppearanceCustomButton.positive => c.strokePositive,
            AppearanceCustomButton.negative => c.strokeNegative,
            AppearanceCustomButton.neutral => c.textPrimary,
          })
        : null;

    final (height, padding, iconPadding, style) = switch (size) {
      SizeCustomButton.s => (30.0, 16.0, 12.0, vk.text.subhead),
      SizeCustomButton.m => (36.0, 16.0, 12.0, vk.text.headline2),
      // На iOS крупные кнопки набираются Title 3
      SizeCustomButton.l => (44.0, 20.0, 16.0, vk.isIOS ? vk.text.title3 : vk.text.headline1),
    };
    final link = mode == ModeCustomButton.link;
    final radius = BorderRadius.circular(vk.borderRadius);

    final label = Text(
      child,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style.copyWith(color: foreground, fontWeight: FontWeight.w500),
    );
    Widget content = Row(
      mainAxisSize: stretched ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (before != null) ...[
          IconTheme(data: IconThemeData(color: foreground), child: before!),
          SizedBox(width: size == SizeCustomButton.l ? 8 : 6),
        ],
        Flexible(child: label),
      ],
    );
    if (loading) {
      content = Stack(alignment: Alignment.center, children: [
        Opacity(opacity: 0, child: content),
        Spinner(size: SpinnerSize.s, color: foreground),
      ]);
    }

    final inactive = disabled || loading;
    return Semantics(
      enabled: !disabled,
      child: Opacity(
        opacity: disabled ? 0.64 : 1,
        child: Tappable(
          onClick: inactive ? null : onClick,
          borderRadius: radius,
          activeColor: primary ? const Color(0x14000000) : null,
          child: Container(
            height: height,
            constraints: BoxConstraints(minWidth: link ? 0 : 80),
            padding: EdgeInsetsDirectional.only(
              start: link ? 0 : (before != null ? iconPadding : padding),
              end: link ? 0 : padding,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: radius,
              border: border,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
