import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/tappable.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

/// VKUI SimpleCell.
class SimpleCell extends StatelessWidget {
  const SimpleCell({
    super.key,
    required this.child,
    this.before,
    this.after,
    this.subtitle,
    this.onClick,
    this.chevron = false,
    this.multiline = false,
    this.color,
  });

  final String child;
  final Widget? before;
  final Widget? after;
  final String? subtitle;
  final VoidCallback? onClick;

  /// Шеврон справа: ячейка ведёт на другой экран.
  final bool chevron;
  final bool multiline;

  /// Цвет текста и иконки, как у VKUI CellButton (`mode="danger"` и т.п.).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final subtitle = this.subtitle;
    final lines = multiline ? null : 1;
    final overflow = multiline ? null : TextOverflow.ellipsis;
    return Tappable(
      onClick: onClick,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: vk.cellHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal),
          child: Row(
            children: [
              if (before != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 6, bottom: 6),
                  child: IconTheme(
                    data: IconThemeData(color: color ?? c.iconAccent),
                    child: before!,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child,
                        maxLines: lines,
                        overflow: overflow,
                        style: vk.text.headline1.copyWith(
                          color: color ?? c.textPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subtitle,
                            maxLines: lines,
                            overflow: overflow,
                            style: vk.text.footnote.copyWith(color: c.textSecondary),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (after != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: IconTheme(
                    data: IconThemeData(color: c.iconAccent),
                    child: DefaultTextStyle(
                      style: vk.text.headline1.copyWith(
                        color: c.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      child: after!,
                    ),
                  ),
                ),
              if (chevron)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: CustomIcon('chevron_24', color: c.iconTertiary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
