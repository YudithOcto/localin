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

  static String formatDateBookingDetail(String value) {
    if (value == null) return '';
    DateTime dateTime = DateTime.parse(value);
    return DateFormat('EEE, d MMMM yyyy').format(dateTime);
  }

  static String formatDateBookingDetailShort(String value) {
    if (value == null) return '';
    DateTime dateTime = DateTime.parse(value);
    return DateFormat('EEE, d MMMM').format(dateTime);
  }

  static String formatFromTimeStampShort(int value) {
    if (value == null) return '';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    return DateFormat('EEE, d MMMM').format(dateTime);
  }

  static String formatFromTimeStamp(int value) {
    if (value == null) return '';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    return DateFormat('dd MMMM yyyy, hh:mm').format(dateTime);
  }

  static DateTime formatGeneralTimeStamp(int value) {
    if (value == null) return DateTime.now();
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  static DateTime formatGeneralFromString(String value) {
    if (value == null) return DateTime.now();
    return DateTime.parse(value).toLocal();
  }
}
