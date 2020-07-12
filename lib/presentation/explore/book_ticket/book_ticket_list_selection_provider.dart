import 'package:flutter/material.dart';
import 'package:localin/model/explore/explore_available_event_dates_model.dart';
import 'package:localin/model/explore/explore_event_detail_model.dart';
import 'package:localin/model/explore/explore_event_submission_details.dart';
import 'package:localin/utils/date_helper.dart';

class BookTicketListSelectionProvider with ChangeNotifier {
  List<ExploreAvailableEventDatesDetail> _availableTickets = [];
  List<ExploreAvailableEventDatesDetail> get availableTickets =>
      _availableTickets;

  ExploreEventDetail _exploreEventDetail;
  ExploreEventDetail get exploreEventDetail => _exploreEventDetail;
  Map<int, int> _totalSelectedQuantity = Map();

  BookTicketListSelectionProvider(ExploreEventDetail eventDetail) {
    this._exploreEventDetail = eventDetail;
    this._availableTickets = eventDetail.available;
    for (int i = 0; i < _availableTickets.length; i++) {
      _totalSelectedQuantity[i] = 0;
    }
  }

  getCurrentTicketQuantity(int index) {
    return _totalSelectedQuantity[index];
  }

  int getTotalSelectedTicket() {
    final values = _totalSelectedQuantity.values;
    return values.reduce((value, element) => value + element);
  }

  int getTotalPriceTicket() {
    int total = 0;

    for (int i = 0; i < _totalSelectedQuantity.length; i++) {
      total += _availableTickets[i].price * _totalSelectedQuantity[i];
    }
    return total;
  }

  addQuantity(int index) {
    int maxQuantity = _availableTickets[index].maxBuyQty;
    if (_totalSelectedQuantity[index] == maxQuantity) return;
    _totalSelectedQuantity[index] = _totalSelectedQuantity[index] + 1;
    notifyListeners();
  }

  subtractQuantity(int index) {
    if (_totalSelectedQuantity[index] == 0) return 0;
    _totalSelectedQuantity[index] = _totalSelectedQuantity[index] - 1;
    notifyListeners();
  }

  ExploreEventSubmissionDetails get eventSubmissionDetail {
    Map<String, int> map = Map();
    for (int i = 0; i < _totalSelectedQuantity.length; i++) {
      int total = _totalSelectedQuantity[i];
      if (total > 0) {
        map[_availableTickets[i].ticketType] = total;
      }
    }
    return ExploreEventSubmissionDetails(
      eventName: _exploreEventDetail.eventName,
      eventImage: _exploreEventDetail.eventBanner,
      eventDate: '$formattedStartDateTime - $formattedEndDateTime',
      totalPrice: getTotalPriceTicket(),
      totalTicket: getTotalSelectedTicket(),
      previousTicketTypeWithTotal: map,
    );
  }

  get formattedStartDateTime {
    if (_exploreEventDetail.startDate == null) return '';
    String date = DateHelper.formatDate(
        date: _exploreEventDetail.startDate,
        format: "EEEE, dd MMMM yyyy 'at' hh:mm");
    return date;
  }

  get formattedEndDateTime {
    if (_exploreEventDetail.endDate == null) return '';
    String date = DateHelper.formatDate(
        date: _exploreEventDetail.endDate,
        format: "EEEE, dd MMMM yyyy 'at' HH:mm");
    return date;
  }
}
