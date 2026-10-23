import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

class TabbarItem {
  const TabbarItem({required this.icon, required this.label});

  /// Имя иконки 28 из @vkontakte/icons.
  final String icon;
  final String label;
}

/// VKUI Tabbar: высота 48 + safe area, на iOS — линия сверху.
class Tabbar extends StatelessWidget {
  const Tabbar({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  final List<TabbarItem> items;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.backgroundTertiary,
        border: vk.isIOS
            ? Border(
                top: BorderSide(
                  color: c.separatorPrimaryAlpha,
                  width: VKTheme.hairline(context),
                ),
              )
            : null,
        boxShadow: vk.isIOS ? null : c.elevation3,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: vk.tabbarHeight,
          child: Row(
            children: [
              for (final (i, item) in items.indexed)
                Expanded(
                  child: _TabbarButton(
                    item: item,
                    selected: i == selected,
                    onTap: () => onChanged(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabbarButton extends StatefulWidget {
  const _TabbarButton({required this.item, required this.selected, required this.onTap});

  final TabbarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TabbarButton> createState() => _TabbarButtonState();
}

class _TabbarButtonState extends State<_TabbarButton> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final selected = widget.selected;
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _active = true),
        onTapUp: (_) => setState(() => _active = false),
        onTapCancel: () => setState(() => _active = false),
        onTap: widget.onTap,
        // На iOS пункт слегка сжимается при нажатии
        child: AnimatedScale(
          scale: _active && vk.isIOS ? 0.96 : 1,
          duration: const Duration(milliseconds: 70),
          curve: vk.easing,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 4, 2, 2),
            child: Column(
              children: [
                CustomIcon(
                  widget.item.icon,
                  color: selected ? c.iconAccentThemed : c.iconSecondary,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: vk.text.tabbarLabel.copyWith(
                    color: selected ? c.textAccentThemed : c.tabbarTextInactive,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
