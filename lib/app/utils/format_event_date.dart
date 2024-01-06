import 'package:intl/intl.dart';

String formatEventDate(String date) {
  return DateFormat('EEEE, dd MMM').format(DateTime.parse(date));
}