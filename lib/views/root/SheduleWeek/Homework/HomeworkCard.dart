import 'package:diary_app/components/avatar.dart';
import 'package:diary_app/components/tokens.dart';
import 'package:diary_app/models/index.dart';
import 'package:flutter/material.dart';

/// Задание в виде VKUI Card (фон `colorBackgroundSecondary`).
class HomeworkCard extends StatelessWidget {
  const HomeworkCard({super.key, required this.homework, this.showAuthor = true});

  final Homework homework;
  final bool showAuthor;

  @override
  Widget build(BuildContext context) {
    final vk = context.vk;
    final c = vk.colors;
    final author = homework.author;
    final (name, caption) = homework.isFromBot
        ? ('Тоби', 'Бот · из электронного дневника')
        : (author?.fullName ?? 'Одноклассник', 'Одноклассник');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: vk.paddingHorizontal, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.backgroundSecondary,
        borderRadius: BorderRadius.circular(vk.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAuthor) ...[
            Row(
              children: [
                homework.isFromBot
                    ? Avatar(
                        size: 32,
                        image: const AssetImage('resource/images/bot.png'),
                      )
                    : Avatar(
                        size: 32,
                        initials: Avatar.initialsOf(name),
                        gradient: author?.userId ?? 0,
                      ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: vk.text.headline2.copyWith(color: c.textPrimary)),
                      Text(caption, style: vk.text.caption1.copyWith(color: c.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Text(homework.task.text, style: vk.text.text.copyWith(color: c.textPrimary)),
          if (!showAuthor) ...[
            const SizedBox(height: 6),
            Text(
              homework.isPublic ? 'Видно классу' : 'Видно только вам',
              style: vk.text.caption1.copyWith(color: c.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
