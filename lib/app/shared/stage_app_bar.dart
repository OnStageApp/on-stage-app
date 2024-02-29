import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart'; // Ensure this import exists for theme constants
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StageAppBar({
    required this.title,
    this.trailing,
    this.isBackButtonVisible = false,
    this.canBack,
    this.onBack,
    this.titleWidget,
    this.isCloseIcon,
    this.actions,
    this.centerTitle,
    this.titleTextStyle,
    super.key,
  });

  final String title;
  final bool isBackButtonVisible;
  final Widget? trailing;
  final bool? canBack;
  final VoidCallback? onBack;
  final Widget? titleWidget;
  final bool? isCloseIcon;
  final List<Widget>? actions;
  final bool? centerTitle;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.colorScheme.background,
      title: titleWidget ?? Text(title, style: titleTextStyle ?? context.textTheme.headlineSmall?.copyWith(color: context.colorScheme.shadow)),
      centerTitle: centerTitle ?? true,
      automaticallyImplyLeading: false,
      leading: _buildLeading(context),
      actions: actions ?? [trailing ?? const SizedBox()],
      surfaceTintColor: context.colorScheme.onSurface,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (onBack != null || canBack == true || isBackButtonVisible) {
      return IconButton(
        icon: Icon(
          isCloseIcon == true ? Icons.close : Icons.arrow_back,
        ),
        onPressed: onBack ?? () => Navigator.pop(context),
      );
    }
    return null; // Return null if no leading widget is to be displayed
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Use Flutter's default toolbar height
}
