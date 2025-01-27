import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

enum TextSize {
  small,
  normal,
  large,
}

extension TextSizeExtension on TextSize {
  double size(BuildContext context) {
    if (context.isLargeScreen) {
      switch (this) {
        case TextSize.small:
          return 20;
        case TextSize.normal:
          return 24;
        case TextSize.large:
          return 26;
      }
    } else {
      switch (this) {
        case TextSize.small:
          return 16;
        case TextSize.normal:
          return 18;
        case TextSize.large:
          return 20;
      }
    }
  }
}
