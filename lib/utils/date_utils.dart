import 'package:intl/intl.dart';



class DateUtils {
  static DateFormat format = DateFormat("MMM dd, yyyy");

  static DateTime? parseDate(String date) {
    try {
      return format.parse(date);
    } catch (e) {
      print('$e');
    }
    return null;
  }
}