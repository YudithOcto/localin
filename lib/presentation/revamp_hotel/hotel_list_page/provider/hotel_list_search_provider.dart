import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/utils/date_helper.dart';

class HotelListSearchProvider with ChangeNotifier {
  HotelListSearchProvider({RevampHotelListRequest request}) {
    _currentCheckInDate = request.checkIn.parseDate;
    _currentCheckOutDate = request.checkout.parseDate;
    _totalRoomsRequested = request.totalRooms;
  }

  String _currentCheckInDate = DateTime.now().parseDate;
  String get currentCheckInDate => _currentCheckInDate;

  set checkInDate(DateTime now) {
    _currentCheckInDate = now.parseDate;
    _checkInDate = now;
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

  String _currentCheckOutDate =
      'CHECK OUT:  ${DateTime.now().add(Duration(days: 1)).parseDate.toUpperCase()}';
  String get currentCheckOutDate => _currentCheckOutDate;
  set checkOutDate(String date) {
    _currentCheckOutDate = date.toUpperCase();
    notifyListeners();
  }

  int _totalRoomsRequested = 1;
  int get totalRoomsRequested => _totalRoomsRequested;

  DateTime _checkInDate;
  DateTime _checkOutDate;
}

extension on DateTime {
  String get parseDate {
    return DateHelper.formatDate(
        date: this == null ? DateTime.now() : this, format: 'EEE, dd MMM yyyy');
  }
}
