import 'package:intl/intl.dart';

class DateHelper {
  static String formatDateRangeToString(DateTime value) {
    if (value == null) return '';
    String dateValue = DateFormat('dd MMMM yyyy').format(value);
    return dateValue;
  }

  static String formatDateFromApi(String value) {
    if (value == null) return '';
    DateTime dateTime = DateTime.parse(value);
    return DateFormat('dd MMMM yyyy, hh:mm').format(dateTime);
  }
}
