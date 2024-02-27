import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

AppBar customAppBar(
  BuildContext context,
  String title, {
  bool? canBack,
  VoidCallback? onBack,
  Widget? titleWidget,
  bool? isCloseIcon,
  List<Widget>? actions,
  bool? centerTitle,
  TextStyle? titleTextStyle,
}) =>
    AppBar(
      backgroundColor: context.colorScheme.background,
      title: titleWidget ?? Text(title),
      centerTitle: centerTitle ?? true,
      titleTextStyle: titleTextStyle ??
          context.textTheme.headlineSmall
              ?.copyWith(color: context.colorScheme.shadow),
      automaticallyImplyLeading: false,
      leading: onBack != null || canBack == true
          ? IconButton(
              icon: Icon(
                isCloseIcon == true ? Icons.close : Icons.arrow_back,
              ),
              onPressed: onBack ?? () => Navigator.pop(context),
            )
          : null,
      actions: actions,
      surfaceTintColor: context.colorScheme.onSurface,
    );
