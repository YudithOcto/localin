import 'package:flutter/material.dart';
import 'package:localin/model/explore/explore_available_event_dates_model.dart';

class CalendarTicketProvider with ChangeNotifier {
//  int getTotalSelectedTicket() {
//    final values = _totalSelectedQuantity.values;
//    return values.reduce((value, element) => value + element);
//  }
//
//  int getTotalPriceTicket() {
//    int total = 0;
//
//    for (int i = 0; i < _totalSelectedQuantity.length; i++) {
//      total += _availableTickets[i].price * _totalSelectedQuantity[i];
//    }«
//    return total;
//  }
//

  // key = selected date, value = list of ticket of that selected date
  Map<DateTime, List<ExploreAvailableEventDatesDetail>> _currentSelectedTicket =
      Map();
  void addSelectedDateAndTicket(
      DateTime dateTime, List<ExploreAvailableEventDatesDetail> detail) {
    _currentSelectedTicket[dateTime] = detail;
    notifyListeners();
  }

  List<ExploreAvailableEventDatesDetail> get listTicket {
    if (_currentSelectedTicket.isEmpty) {
      return [];
    }
    return _currentSelectedTicket.values
        .reduce((value, element) => value + element);
  }
}
