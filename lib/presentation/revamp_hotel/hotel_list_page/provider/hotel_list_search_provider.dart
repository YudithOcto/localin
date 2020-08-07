import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:localin/utils/date_helper.dart';

class HotelListSearchProvider with ChangeNotifier {
  String _currentCheckInDate = DateTime.now().parseDate;
  String get currentCheckInDate => _currentCheckInDate;
  set checkInDate(DateTime now) {
    _currentCheckInDate = now.parseDate;
    notifyListeners();
  }

  List<String> getListCheckOutDate() {
    DateTime dateTime =
        DateFormat('EEE, dd MMM yyyy').parse(_currentCheckInDate);
    List<String> result = [];
    for (int i = 0; i <= 20; i++) {
      result.add('Check-out ${dateTime.add(Duration(days: i + 1)).parseDate}');
    }
    return result;
  }
}

extension on DateTime {
  String get parseDate {
    return DateHelper.formatDate(
        date: this == null ? DateTime.now() : this, format: 'EEE, dd MMM yyyy');
  }
}
