import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

/// Градиенты инициалов VKUI Avatar.
const _gradients = [
  [Color(0xFFFF7583), Color(0xFFE52E40)],
  [Color(0xFFFFBF80), Color(0xFFE66B2E)],
  [Color(0xFFFFD54F), Color(0xFFE7A902)],
  [Color(0xFF6CD97E), Color(0xFF12B212)],
  [Color(0xFF7DF1FA), Color(0xFF2BB4D6)],
  [Color(0xFF66CCFF), Color(0xFF3F8AE0)],
  [Color(0xFFD3A6FF), Color(0xFF8F3FE0)],
];

/// VKUI Avatar: картинка или инициалы на градиенте.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.size = 48,
    this.initials,
    this.gradient = 5,
    this.image,
  });

  final double size;
  final String? initials;

  /// Номер градиента; удобно брать id пользователя.
  final int gradient;
  final ImageProvider? image;

  /// Инициалы «Анна Смирнова» → «АС», союзы и предлоги пропускаем.
  static String initialsOf(String name) {
    final words = name.split(' ').where((word) => word.isNotEmpty);
    final long = words.where((word) => word.length > 2);
    return (long.isEmpty ? words : long)
        .take(2)
        .map((word) => word[0])
        .join()
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[gradient % _gradients.length];
    final image = this.image;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: image == null ? null : DecorationImage(image: image),
        gradient: image == null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              )
            : null,
      ),
      foregroundDecoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.colors.imageBorderAlpha,
          width: VKTheme.hairline(context),
        ),
      ),
      child: image == null && initials != null
          ? Text(
              initials!,
              style: TextStyle(
                color: Colors.white,
                fontSize: (size * 0.36).roundToDouble(),
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            )
          : null,
    );
  }
}
