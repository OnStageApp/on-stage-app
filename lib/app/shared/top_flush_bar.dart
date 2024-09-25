import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TopFlushBar {
  static void show(BuildContext context, String message,
      {bool isError = false}) {
    Flushbar(
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
        size: 20,
      ),
      padding: const EdgeInsets.symmetric(vertical: 18),
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      borderRadius: BorderRadius.circular(10),
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? context.colorScheme.error : Colors.green,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    ).show(context);
  }
}
