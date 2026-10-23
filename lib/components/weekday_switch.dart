import 'package:diary_app/components/tappable.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:flutter/material.dart';

const _weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

/// Дни недели в виде VKUI Tabs `mode="secondary"`.
class WeekDaySwitch extends StatelessWidget {
  const WeekDaySwitch({super.key, required this.activeEl, required this.onTap});

  /// Индекс выбранного дня: 0 — понедельник.
  final int activeEl;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final radius = BorderRadius.circular(vk.borderRadius);
    return ColoredBox(
      color: c.backgroundContent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 8),
        child: Row(
          children: [
            for (final (i, day) in _weekdays.indexed) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: Semantics(
                  selected: i == activeEl,
                  child: Tappable(
                    onClick: () => onTap(i),
                    borderRadius: radius,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: i == activeEl ? c.backgroundSecondaryAlpha : null,
                        borderRadius: radius,
                      ),
                      child: Text(
                        day,
                        style: vk.text.headline2.copyWith(
                          color: i == activeEl ? c.textPrimary : c.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// VKUI SegmentedControl.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final Map<T, String> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final keys = options.keys.toList();
    final index = keys.indexOf(value);
    final radius = BorderRadius.circular(vk.borderRadius);
    return Container(
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: c.backgroundSecondary, borderRadius: radius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth / keys.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                curve: vk.easing,
                left: width * index,
                width: width,
                top: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.segmentedControl,
                    borderRadius: radius,
                    border: Border.all(
                      color: c.imageBorderAlpha,
                      width: VKTheme.hairline(context),
                    ),
                    boxShadow: c.elevation2,
                  ),
                ),
              ),
              Row(
                children: [
                  for (final key in keys)
                    Expanded(
                      child: Semantics(
                        selected: key == value,
                        button: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onChanged(key),
                          child: Center(
                            child: Text(
                              options[key]!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: vk.text.headline2.copyWith(color: c.textPrimary),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
