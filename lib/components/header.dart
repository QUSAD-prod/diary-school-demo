import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

enum HeaderSize { s, m, l }

/// VKUI Header — заголовок группы.
class Header extends StatelessWidget {
  const Header(this.header, {super.key, this.size = HeaderSize.m, this.after});

  final String header;
  final HeaderSize size;
  final Widget? after;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final style = switch (size) {
      HeaderSize.l => vk.text.title3.copyWith(color: c.textPrimary),
      HeaderSize.m => vk.text.headline1.copyWith(color: c.textPrimary),
      HeaderSize.s => vk.text.footnoteCaps.copyWith(color: c.textSecondary),
    };
    return Padding(
      padding: EdgeInsets.fromLTRB(vk.paddingHorizontal, 12, vk.paddingHorizontal, 8),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                size == HeaderSize.s ? header.toUpperCase() : header,
                style: style,
              ),
            ),
          ),
          if (after != null)
            DefaultTextStyle(
              style: vk.text.paragraph.copyWith(color: c.textSecondary),
              child: after!,
            ),
        ],
      ),
    );
  }
}

/// VKUI Group. В режиме [card] — карточка на сером фоне, как группы
/// в мобильном VKUI; первая прилегает к шапке.
class Group extends StatelessWidget {
  const Group({
    super.key,
    required this.children,
    this.header,
    this.description,
    this.card = false,
    this.first = false,
  });

  final List<Widget> children;
  final Widget? header;
  final String? description;
  final bool card;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final description = this.description;
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null)
            Transform.translate(offset: Offset(0, card ? -4 : 0), child: header),
          ...children,
          if (description != null)
            Padding(
              padding: EdgeInsets.fromLTRB(vk.paddingHorizontal, 4, vk.paddingHorizontal, 8),
              child: Text(
                description,
                style: vk.text.footnote.copyWith(color: vk.colors.textSecondary),
              ),
            ),
        ],
      ),
    );
    if (!card) return content;

    // sizeBorderRadiusPromo — скругление карточек на мобильных
    const radius = Radius.circular(20);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: vk.colors.backgroundContent,
        borderRadius: first
            ? const BorderRadius.vertical(bottom: radius)
            : const BorderRadius.all(radius),
      ),
      child: content,
    );
  }
}

/// VKUI Separator: линия толщиной в физический пиксель.
class Separator extends StatelessWidget {
  const Separator({super.key, this.padded = true});

  final bool padded;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padded ? vk.paddingHorizontal : 0),
      child: SizedBox(
        height: VKTheme.hairline(context),
        child: ColoredBox(color: vk.colors.separatorPrimary),
      ),
    );
  }
}
