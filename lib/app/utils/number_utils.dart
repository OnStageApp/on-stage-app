import 'package:intl/intl.dart';

extension PercentageFormat on num {
  static final _signedPercentageFormat = NumberFormat('+##.##%;-##.##%');

  /// Format this number as follows:
  /// 1.5 => +1.5%
  /// -1.5 => -1.5%
  String toSignedPercentage() {
    return this == 0 ? '0%' : _signedPercentageFormat.format(this / 100);
  }

  /// Format this number as follows:
  /// 1.5 => 1.5%
  /// -1.5 => -1.5%
  String toPercentage() {
    return this == 0
        ? '0%'
        : NumberFormat.decimalPercentPattern(decimalDigits: 2).format(this);
  }
}
