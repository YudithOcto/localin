import 'package:intl/intl.dart';

class DateHelper {
  static String formatDateRangeToString(DateTime value) {
    String dateValue = DateFormat('dd MMMM yyyy').format(value);
    return dateValue;
  }
}
