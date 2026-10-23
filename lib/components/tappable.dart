import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

/// Аналог VKUI Tappable: подсветка фона при нажатии вместо ripple.
class Tappable extends StatefulWidget {
  const Tappable({
    super.key,
    required this.child,
    this.onClick,
    this.borderRadius,
    this.activeColor,
    this.activeOpacity,
  });

  final Widget child;
  final VoidCallback? onClick;
  final BorderRadius? borderRadius;

  /// Цвет подсветки, по умолчанию `colorTransparent--active`.
  final Color? activeColor;

  /// Вместо подсветки меняет прозрачность (кнопки шапки на iOS).
  final double? activeOpacity;

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> {
  bool _active = false;

  void _setActive(bool value) {
    if (_active != value) setState(() => _active = value);
  }

  @override
  Widget build(BuildContext context) {
    final onClick = widget.onClick;
    if (onClick == null) return widget.child;

    final Widget child = widget.activeOpacity != null
        ? AnimatedOpacity(
            opacity: _active ? widget.activeOpacity! : 1,
            duration: const Duration(milliseconds: 100),
            child: widget.child,
          )
        : DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              color: _active
                  ? widget.activeColor ?? context.colors.transparentActive
                  : null,
              borderRadius: widget.borderRadius,
            ),
            child: widget.child,
          );

    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setActive(true),
        onTapUp: (_) => _setActive(false),
        onTapCancel: () => _setActive(false),
        onTap: onClick,
        child: child,
      ),
    );
  }
}
