import 'package:diary_app/components/panel_header.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

/// Открывает VKUI ModalPage: лист снизу со скруглением 12 сверху.
Future<T?> showModalPage<T>(BuildContext context, WidgetBuilder builder) {
  final vk = context.vk;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: vk.colors.backgroundModal,
    barrierColor: vk.colors.overlayPrimary,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(vk.borderRadiusPaper)),
    ),
    builder: builder,
  );
}

/// Содержимое ModalPage: шапка и прокручиваемое тело по высоте контента.
class ModalPage extends StatelessWidget {
  const ModalPage({
    super.key,
    required this.title,
    required this.child,
    this.action,
  });

  final String title;
  final Widget child;

  /// Дополнительная кнопка в шапке.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final isIOS = context.vk.isIOS;
    // Как в VKUI: на iOS крестик справа, на Android — слева
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PanelHeader(
          safeArea: false,
          background: context.colors.backgroundModal,
          title: Text(title),
          before: isIOS ? action : const PanelHeaderClose(),
          after: isIOS ? const PanelHeaderClose() : action,
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 8),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// VKUI Snackbar поверх нижнего края экрана.
void showSnackbar(BuildContext context, String text) {
  final vk = context.vk;
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      duration: const Duration(seconds: 4),
      content: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: vk.colors.backgroundContrastThemed,
          borderRadius: BorderRadius.circular(vk.borderRadius),
          boxShadow: vk.colors.elevation4,
        ),
        child: Text(
          text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: vk.text.paragraph.copyWith(color: vk.colors.textPrimary),
        ),
      ),
    ),
  );
}
