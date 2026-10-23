import 'package:diary_app/components/form_item.dart';
import 'package:diary_app/components/icon.dart';
import 'package:diary_app/components/tappable.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// VKUI Input. С [isPass] показывает кнопку «показать пароль».
class Input extends StatefulWidget {
  const Input({
    super.key,
    this.controller,
    this.placeholder,
    this.isPass = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.autofillHints,
    this.onSubmit,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final bool isPass;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmit;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late bool _hidden = widget.isPass;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      onSubmitted: widget.onSubmit,
      obscureText: _hidden,
      autocorrect: !widget.isPass,
      enableSuggestions: !widget.isPass,
      style: vk.text.text.copyWith(color: vk.colors.textPrimary),
      cursorColor: vk.colors.strokeAccent,
      decoration: fieldDecoration(
        context,
        placeholder: widget.placeholder,
        after: widget.isPass
            ? Semantics(
                label: _hidden ? 'Показать пароль' : 'Скрыть пароль',
                child: Tappable(
                  onClick: () => setState(() => _hidden = !_hidden),
                  activeOpacity: 0.6,
                  child: SizedBox.square(
                    dimension: 44,
                    child: Center(
                      child: CustomIcon(
                        _hidden ? 'view_outline_24' : 'hide_outline_24',
                        color: vk.colors.iconSecondary,
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

/// VKUI Textarea.
class Textarea extends StatelessWidget {
  const Textarea({super.key, this.controller, this.placeholder});

  final TextEditingController? controller;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    return TextField(
      controller: controller,
      minLines: 3,
      maxLines: 8,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      style: vk.text.text.copyWith(color: vk.colors.textPrimary),
      cursorColor: vk.colors.strokeAccent,
      decoration: fieldDecoration(context, placeholder: placeholder),
    );
  }
}

/// VKUI SelectMimicry: выглядит как поле, по нажатию открывает выбор.
class SelectMimicry extends StatelessWidget {
  const SelectMimicry({
    super.key,
    this.value,
    this.placeholder = '',
    required this.onClick,
  });

  final String? value;
  final String placeholder;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final radius = BorderRadius.circular(vk.borderRadius);
    return Tappable(
      onClick: onClick,
      borderRadius: radius,
      child: Container(
        constraints: BoxConstraints(minHeight: vk.fieldHeight),
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: c.fieldBackground,
          borderRadius: radius,
          border: Border.all(
            color: c.fieldBorderAlpha,
            width: VKTheme.hairline(context),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: vk.text.text.copyWith(
                  color: value == null ? c.textSecondary : c.textPrimary,
                ),
              ),
            ),
            SizedBox(
              width: 44,
              child: CustomIcon('chevron_down_24', color: c.iconSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
