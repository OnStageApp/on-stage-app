import 'package:flutter/material.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StageAppBar({
    required this.title,
    this.trailing,
    this.isBackButtonVisible = false,
    super.key,
  });

  final String title;
  final bool isBackButtonVisible;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AppBar(
        backgroundColor: context.colorScheme.background,
        leading: _buildLeading(context),
        centerTitle: isBackButtonVisible,
        title: Text(
          title,
          style: context.textTheme.headlineMedium?.copyWith(
            fontSize: isBackButtonVisible ? 20 : 28,
            color: context.colorScheme.shadow,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [trailing ?? const SizedBox()],
        surfaceTintColor: context.colorScheme.onSurface,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (isBackButtonVisible) {
      return IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () => context.pop(),
      );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(defaultAppBarHeight);
}
