import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/tappable.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool get _isIOS =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS;

/// VKUI PanelHeader: на iOS заголовок по центру, на Android — слева.
class PanelHeader extends StatelessWidget implements PreferredSizeWidget {
  const PanelHeader({
    super.key,
    this.title,
    this.before,
    this.after,
    this.safeArea = true,
    this.background,
  });

  final Widget? title;
  final Widget? before;
  final Widget? after;

  /// В модальных окнах отступ под статус-бар не нужен.
  final bool safeArea;
  final Color? background;

  @override
  Size get preferredSize => Size.fromHeight(_isIOS ? 52 : 56);

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final title = this.title;
    return ColoredBox(
      color: background ?? vk.colors.headerBackground,
      child: SafeArea(
        top: safeArea,
        bottom: false,
        child: SizedBox(
          height: vk.panelHeaderHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: IconTheme(
              data: IconThemeData(color: vk.colors.iconAccentThemed),
              child: NavigationToolbar(
                leading: before,
                trailing: after,
                centerMiddle: vk.isIOS,
                middleSpacing: before == null && !vk.isIOS ? 12 : 4,
                middle: title == null
                    ? null
                    : DefaultTextStyle(
                        style: vk.text.panelHeader
                            .copyWith(color: vk.colors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: Semantics(header: true, child: title),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Кнопка шапки: иконка 28 в квадрате 44 (iOS) или 48 (Android).
class PanelHeaderButton extends StatelessWidget {
  const PanelHeaderButton({
    super.key,
    required this.child,
    required this.onClick,
    this.label,
  });

  final Widget child;
  final VoidCallback? onClick;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final size = vk.isIOS ? 44.0 : 48.0;
    return Semantics(
      label: label,
      child: Tappable(
        onClick: onClick,
        activeOpacity: vk.isIOS ? 0.6 : null,
        borderRadius: BorderRadius.circular(size / 2),
        child: SizedBox.square(dimension: size, child: Center(child: child)),
      ),
    );
  }
}

class PanelHeaderBack extends StatelessWidget {
  const PanelHeaderBack({super.key, this.onClick});

  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) => PanelHeaderButton(
        label: 'Назад',
        onClick: onClick ?? () => Navigator.maybePop(context),
        child: CustomIcon(
          context.vk.isIOS ? 'chevron_back_28' : 'arrow_left_outline_28',
        ),
      );
}

/// Закрытие модального окна: крестик справа на iOS, слева на Android.
class PanelHeaderClose extends StatelessWidget {
  const PanelHeaderClose({super.key});

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return PanelHeaderButton(
      label: 'Закрыть',
      onClick: () => Navigator.maybePop(context),
      child: vk.isIOS
          ? CustomIcon('dismiss_24', color: vk.colors.iconSecondary)
          : const CustomIcon('cancel_outline_28'),
    );
  }
}
