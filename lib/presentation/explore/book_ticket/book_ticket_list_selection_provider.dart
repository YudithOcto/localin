import 'package:flutter/material.dart';
import 'package:localin/model/explore/explore_available_event_dates_model.dart';
import 'package:localin/model/explore/explore_event_detail.dart';
import 'package:localin/model/explore/explore_event_submission_details.dart';
import 'package:localin/model/explore/explore_schedule_model.dart';
import 'package:localin/utils/date_helper.dart';

class BookTicketListSelectionProvider with ChangeNotifier {
  ExploreEventDetail _currentEventDetail;
  BookTicketListSelectionProvider({ExploreEventDetail detail}) {
    _currentEventDetail = detail;
  }

  List<ExploreAvailableEventDatesDetail> _availableTickets = [];
  List<ExploreAvailableEventDatesDetail> get availableTickets =>
      _availableTickets;

  int _globalMaxQuantity = 0;

  // we should track ticket type rather than index
  Map<int, int> _totalSelectedSingleTicket = Map();

  addAvailableTickets(List<ExploreScheduleModel> scheduleList, int maxQty) {
    _globalMaxQuantity = maxQty;
    scheduleList.forEach((schedule) {
      _availableTickets.addAll(schedule.available);
    });
    _availableTickets.forEach((availableTicket) {
      _totalSelectedSingleTicket[availableTicket.idTicket] = 0;
    });
  }

  getCurrentTicketQuantity(int idTicket) {
    return _totalSelectedSingleTicket[idTicket];
  }

  int get totalSelectedTicket {
    if (_totalSelectedSingleTicket.isEmpty) return 0;
    final values = _totalSelectedSingleTicket.values;
    return values.reduce((value, element) => value + element);
  }

  int get totalPriceTicket {
    int total = 0;

    _totalSelectedSingleTicket.forEach((key, value) {
      final item = _availableTickets.singleWhere((element) {
        return element.idTicket == key;
      });
      total += item.price * _totalSelectedSingleTicket[key];
    });
    return total;
  }

  String addQuantity(int idTicket, int singleTicketMaxBuy) {
    if (_totalSelectedSingleTicket.containsKey(idTicket)) {
      if (_totalSelectedSingleTicket[idTicket] < singleTicketMaxBuy &&
          totalSelectedTicket < _globalMaxQuantity) {
        _totalSelectedSingleTicket[idTicket] += 1;
        notifyListeners();
        return '';
      } else {
        return 'Maximum ticket book limit reached. You cannot add more ticket.';
      }
    } else {
      return '';
    }
  }

  subtractQuantity(int idTicket) {
    if (_totalSelectedSingleTicket.containsKey(idTicket)) {
      if (_totalSelectedSingleTicket[idTicket] > 0) {
        _totalSelectedSingleTicket[idTicket] -= 1;
      }
    }
    notifyListeners();
  }

  ExploreEventSubmissionDetails get eventSubmissionDetail {
    List<ExploreAvailableEventDatesDetail> _eventRequestModel = List();
    _totalSelectedSingleTicket.forEach((key, value) {
      // value == total qty single ticket type request
      if (_totalSelectedSingleTicket[key] > 0) {
        final item =
            _availableTickets.singleWhere((element) => element.idTicket == key);
        for (int i = 0; i < value; i++) {
          _eventRequestModel.add(item);
        }
      }
    });
    return ExploreEventSubmissionDetails(
      eventName: _currentEventDetail.eventName,
      eventImage: _currentEventDetail.eventBanner,
      eventDate: '$formattedStartDateTime - $formattedEndDateTime',
      totalPrice: totalPriceTicket,
      totalTicket: totalSelectedTicket,
      previousTicketTypeWithTotal: _eventRequestModel,
    );
  }

  get formattedStartDateTime {
    if (_currentEventDetail.startDate == null) return '';
    String date = DateHelper.formatDate(
        date: _currentEventDetail.startDate,
        format: "EEEE, dd MMMM yyyy 'at' hh:mm");
    return date;
  }

  get formattedEndDateTime {
    if (_currentEventDetail.endDate == null) return '';
    String date = DateHelper.formatDate(
        date: _currentEventDetail.endDate,
        format: "EEEE, dd MMMM yyyy 'at' HH:mm");
    return date;
  }
}
