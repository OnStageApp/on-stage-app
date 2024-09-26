enum TextSize {
  small,
  normal,
  large,
}

extension TextSizeExtension on TextSize {
  double get size {
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
