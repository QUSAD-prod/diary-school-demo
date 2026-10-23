import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Иконка из набора @vkontakte/icons (`resource/icons/<name>.svg`).
///
/// Размер берётся из суффикса имени (`add_outline_28` → 28),
/// цвет — из [IconTheme], как `currentColor` в VKUI.
class CustomIcon extends StatelessWidget {
  const CustomIcon(this.name, {super.key, this.size, this.color});

  final String name;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? IconTheme.of(context).color!;
    return SvgPicture.asset(
      'resource/icons/$name.svg',
      height: size ?? double.parse(name.substring(name.lastIndexOf('_') + 1)),
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
  }
}
