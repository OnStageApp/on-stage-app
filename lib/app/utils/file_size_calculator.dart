/// Utility class for formatting file sizes in human-readable format
class FileSizeCalculator {
  // Private constructor to prevent instantiation
  FileSizeCalculator._();

  /// Constants for size conversions
  static const int _kb = 1024;
  static const int _mb = _kb * 1024;
  static const int _gb = _mb * 1024;

  /// Formats a file size in bytes to a human-readable string
  ///
  /// Automatically selects the appropriate unit (B, KB, MB, GB)
  static String formatSize(int bytes, {int decimals = 2}) {
    if (bytes < _kb) {
      return '$bytes B';
    } else if (bytes < _mb) {
      return '${(bytes / _kb).toStringAsFixed(decimals)} KB';
    } else if (bytes < _gb) {
      return '${(bytes / _mb).toStringAsFixed(decimals)} MB';
    } else {
      return '${(bytes / _gb).toStringAsFixed(decimals)} GB';
    }
  }

  /// Converts bytes to kilobytes
  static double bytesToKB(int bytes) => bytes / _kb;

  /// Converts bytes to megabytes
  static double bytesToMB(int bytes) => bytes / _mb;

  /// Converts bytes to gigabytes
  static double bytesToGB(int bytes) => bytes / _gb;
}
