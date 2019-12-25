import 'package:intl/intl.dart';

class DateHelper {
  static String formatDateRangeToString(DateTime value) {
    String dateValue = DateFormat('dd MMMM yyyy').format(value);
    return dateValue;
  }

  static String formatDateFromApi(String value) {
    DateTime dateTime = DateTime.parse(value);
    return DateFormat('EEEE, dd MMMM yyyy').format(dateTime);
  }
}
