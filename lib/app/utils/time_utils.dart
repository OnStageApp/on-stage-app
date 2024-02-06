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
}
