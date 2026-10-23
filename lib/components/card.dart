import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

/// VKUI Card с `mode="shadow"`.
class ShadowCard extends StatelessWidget {
  const ShadowCard({super.key, required this.child, this.margin});

  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final radius = BorderRadius.circular(vk.borderRadius);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: vk.colors.backgroundContrastThemed,
        borderRadius: radius,
        boxShadow: vk.colors.elevation3,
      ),
      child: ClipRRect(borderRadius: radius, child: child),
    );
  }
}

/// VKUI Banner `mode="tint"`: информационный блок.
class CustomBanner extends StatelessWidget {
  const CustomBanner({
    super.key,
    required this.header,
    required this.child,
    this.before,
  });

  final String header;
  final String child;
  final Widget? before;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.backgroundSecondary,
        borderRadius: BorderRadius.circular(vk.borderRadiusPaper),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (before != null) ...[
            IconTheme(data: IconThemeData(color: c.iconAccent), child: before!),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(header, style: vk.text.headline1.copyWith(color: c.textPrimary)),
                const SizedBox(height: 2),
                Text(child, style: vk.text.subhead.copyWith(color: c.textSubhead)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
