import 'dart:math' as math;

import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

enum SpinnerSize { s, m, l, xl }

/// VKUI Spinner: дуга 16/24/32/44, один оборот за 0.7 с.
class Spinner extends StatefulWidget {
  const Spinner({super.key, this.size = SpinnerSize.m, this.color});

  final SpinnerSize size;

  /// По умолчанию `colorIconMedium`, как в VKUI.
  final Color? color;

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Уважаем системную настройку «Уменьшение движения»
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (size, stroke) = switch (widget.size) {
      SpinnerSize.s => (16.0, 1.5),
      SpinnerSize.m => (24.0, 1.8),
      SpinnerSize.l => (32.0, 3.0),
      SpinnerSize.xl => (44.0, 3.0),
    };
    return Semantics(
      label: 'Загрузка',
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          size: Size.square(size),
          painter: _SpinnerPainter(
            color: widget.color ?? context.colors.iconMedium,
            stroke: stroke,
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.color, required this.stroke});

  final Color color;
  final double stroke;

  // Дуга иконок Icon*Spinner: от ~155° по часовой до 90° (низ круга)
  static const _start = 155 * math.pi / 180;
  static const _sweep = 295 * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawArc(
      rect.deflate(stroke / 2),
      _start,
      _sweep,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter old) =>
      old.color != color || old.stroke != stroke;
}
