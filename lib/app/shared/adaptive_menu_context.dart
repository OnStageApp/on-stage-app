import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:pull_down_button/pull_down_button.dart';

part 'adaptive_menu_context.freezed.dart';

@freezed
class MenuAction with _$MenuAction {
  const factory MenuAction({
    required String title,
    VoidCallback? onTap,
    IconData? icon,
    Uint8List? image,
    @Default(false) bool isDestructive,
  }) = _MenuAction;
}

class AdaptiveMenuContext extends StatelessWidget {
  const AdaptiveMenuContext({
    required this.items,
    required this.child,
    super.key,
  });

  final List<MenuAction> items;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS) {
      return PullDownButton(
        itemBuilder: (context) => items
            .map(
              (item) => PullDownMenuItem(
                title: item.title,
                icon: item.icon,
                iconWidget: item.image != null
                    ? ImageWithPlaceholder(
                        photo: item.image,
                        name: item.title,
                      )
                    : null,
                onTap: item.onTap,
                isDestructive: item.isDestructive,
              ),
            )
            .toList(),
        buttonBuilder: (_, showMenu) => InkWell(
          onTap: showMenu,
          child: child,
        ),
      );
    }

    return SizedBox(
      height: 24,
      child: PopupMenuButton<MenuAction>(
        padding: EdgeInsets.zero,
        icon: child,
        onSelected: (item) => item.onTap?.call(),
        position: PopupMenuPosition.under,
        offset: const Offset(0, 8),
        elevation: 3,
        itemBuilder: (context) => items.map((item) {
          return PopupMenuItem<MenuAction>(
            value: item,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.image != null) ...[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: ImageWithPlaceholder(
                      photo: item.image,
                      name: item.title,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    color: Colors.black54,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
