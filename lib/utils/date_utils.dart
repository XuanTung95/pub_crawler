import 'package:intl/intl.dart';



class DateUtils {
  static DateFormat format = DateFormat("MMM dd, yyyy");

  static DateTime parseDate(String date) {
    return format.parse(date);
  }
}