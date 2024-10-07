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

  String formatDateTime(DateTime? datetime) {
    return datetime != null ? DateFormat('EEEE, dd MMMM').format(datetime) : '';
  }

  String formatOnlyDate(DateTime? dateTime) {
    try {
      return dateTime != null ? DateFormat('d MMMM').format(dateTime) : '';
    } catch (e) {
      return 'Invalid date';
    }
  }

  String formatOnlyTime(DateTime? dateTime) {
    return dateTime != null ? DateFormat('HH:mm').format(dateTime) : '';
  }

  DateTime? parseDateTime(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  DateTime approximateToNearestTen(DateTime dateTime) {
    final minute = dateTime.minute;
    final remainder = minute % 5;

    final adjustment = remainder < 5 ? (10 - remainder) : (10 - remainder);

    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      minute + adjustment,
    );
  }
}
