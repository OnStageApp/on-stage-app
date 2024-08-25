import 'package:intl/intl.dart';

class TimeUtils {
  DateTime getEndOfTheWeekDateTime() {
    final now = DateTime.now().subtract(Duration(hours: DateTime.now().hour));
    const lastDayOfWeek = DateTime.sunday;
    final remainingDays = lastDayOfWeek - now.weekday;
    final endOfTheWeek = DateTime.now().add(Duration(days: remainingDays));
    return endOfTheWeek;
  }

  DateTime getNowDateTime() {
    return DateTime.now().subtract(Duration(hours: DateTime.now().hour));
  }

  DateTime getYesterdayDateTime() {
    return DateTime.now().subtract(const Duration(days: 1));
  }

  DateTime getStartOfTheNextWeekDateTime() {
    final endOfTheWeek = getEndOfTheWeekDateTime();
    final startOfTheNextWeek = endOfTheWeek.add(const Duration(days: 1));
    return startOfTheNextWeek;
  }

  String formatDate(DateTime? datetime) {
    return datetime != null ? DateFormat('EEEE, dd MMMM').format(datetime) : '';
  }

  String formatOnlyDate(DateTime dateTime) {
    try {
      final formattedDate = DateFormat('d MMMM').format(dateTime);
      return formattedDate;
    } catch (e) {
      return 'Invalid date';
    }
  }

  String formatOnlyTime(DateTime? dateTime) {
    return dateTime != null ? DateFormat('HH:mm').format(dateTime) : '';
  }

  DateTime? parseDateTime(String dateTimeString) {
    try {
      final parts = dateTimeString.split(' ');
      if (parts.length != 2) {
        return null;
      }
      final datePart = parts[0];
      final timePart = parts[1];

      final dateParts = datePart.split('/');
      if (dateParts.length != 3) {
        return null;
      }
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      final timeParts = timePart.split(':');
      if (timeParts.length != 2) {
        return null;
      }
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      return null;
    }
  }
}
