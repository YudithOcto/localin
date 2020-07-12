import 'package:flutter/material.dart';
import 'package:localin/model/explore/explore_event_submission_details.dart';
import 'package:localin/utils/number_helper.dart';

class SubmitFormProvider with ChangeNotifier {
  ExploreEventSubmissionDetails _eventSubmissionDetails;
  ExploreEventSubmissionDetails get eventSubmissionDetails =>
      _eventSubmissionDetails;

  SubmitFormProvider(ExploreEventSubmissionDetails details) {
    _eventSubmissionDetails = details;
  }

  get singlePaxPrice {
    return 'Pax (${_eventSubmissionDetails.totalTicket}) @${getFormattedCurrency(_eventSubmissionDetails.totalPrice)}';
  }

  List<TextEditingController> visitorController = [];

  get getTicketBySection {
    final keys = _eventSubmissionDetails.previousTicketTypeWithTotal.keys;
    return keys.length;
  }

  getTicketBySectionTitle(int index) {
    return _eventSubmissionDetails.previousTicketTypeWithTotal.keys
        .elementAt(index);
  }

  int getTicketTotalPerSection(String keys) {
    return _eventSubmissionDetails.previousTicketTypeWithTotal[keys];
  }
}
