import 'package:intl/intl.dart';

class DateHelper {
  static String formatDateRangeToString(DateTime value) {
    if (value == null) return '';
    String dateValue = DateFormat('dd MMMM yyyy').format(value);
    return dateValue;
  }

  static String formatDateRangeForOYO(DateTime value) {
    if (value == null) return '';
    String dateValue = DateFormat('yyyy-MM-dd').format(value);
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

  static String formatNewsTimeFromString(String value) {
    DateFormat dateFormat = DateFormat('EEE, dd MMMM yyyy HH:MM');
    if (value == null) return dateFormat.format(DateTime.now());
    DateTime date = DateTime.parse(value).toLocal();
    return dateFormat.format(date);
  }

  static String formatDate(
      {DateTime date, String format = 'EEE, dd MMMM yyyy'}) {
    DateFormat dateFormat = DateFormat(format);
    if (date == null) return dateFormat.format(DateTime.now());
    return dateFormat.format(date);
  }

  static String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  static String checkInCheckOutTime(DateTime checkIn, DateTime checkout) {
    return '${formatDate(date: checkIn, format: 'EEE, d MMM')} - ${formatDate(date: checkout, format: 'EEE, d MMM')}, '
        '${checkout.difference(checkIn).inDays} Night';
  }

  static String buildPoliciesCheckInCheckOut(String text, bool isCheckIn) {
    if (text == null || text.isEmpty) return '';
    if (text.length > 8) {
      String timeSlice = text.substring(text.length - 8, text.length);
      return '${isCheckIn ? 'From' : 'Before'} $timeSlice';
    }
    return '';
  }
}
