import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_available_event_dates_model.dart';
import 'package:localin/model/explore/explore_event_submission_details.dart';
import 'package:localin/model/explore/explore_response_model.dart';
import 'package:localin/model/explore/submit_form_request_model.dart';
import 'package:localin/utils/number_helper.dart';

class SubmitFormProvider with ChangeNotifier {
  ExploreEventSubmissionDetails _eventSubmissionDetails;
  ExploreEventSubmissionDetails get eventSubmissionDetails =>
      _eventSubmissionDetails;

  SubmitFormProvider(ExploreEventSubmissionDetails details) {
    _eventSubmissionDetails = details;
    _eventSubmissionDetails.previousTicketTypeWithTotal.forEach((element) {
      visitorController.add(TextEditingController());
    });
  }

  get singlePaxPrice {
    return 'Pax (${_eventSubmissionDetails.totalTicket}) @${getFormattedCurrency(_eventSubmissionDetails.totalPrice)}';
  }

  List<TextEditingController> visitorController = [];

  get totalSelectedTicket {
    return _eventSubmissionDetails.previousTicketTypeWithTotal.length;
  }

  get isButtonNotActive {
    return visitorController.any((element) => element.text.isEmpty);
  }

  SubmitFormRequestModel get eventFormRequestModel {
    List<SubmitProfileTicketModel> profileModel = [];
    int currentId;
    List<String> names = [];

    for (int i = 0;
        i < _eventSubmissionDetails.previousTicketTypeWithTotal.length;
        i++) {
      final ticket = _eventSubmissionDetails.previousTicketTypeWithTotal[i];
      if (currentId == null) {
        names.add(visitorController[i].text);
        if (_eventSubmissionDetails.previousTicketTypeWithTotal.length == 1) {
          profileModel.add(SubmitProfileTicketModel(
            idTicket: ticket.idTicket,
            visitorNames: names,
          ));
        }
        currentId = ticket.idTicket;
      } else {
        if (currentId == ticket.idTicket) {
          names.add(visitorController[i].text);
          if (i ==
              _eventSubmissionDetails.previousTicketTypeWithTotal.length - 1) {
            profileModel.add(SubmitProfileTicketModel(
              idTicket: ticket.idTicket,
              visitorNames: names,
            ));
          }
        } else {
          profileModel.add(SubmitProfileTicketModel(
            idTicket: currentId,
            visitorNames: names,
          ));
          names = List();
          names.add(visitorController[i].text);
          currentId = ticket.idTicket;
        }
      }
    }

    return SubmitFormRequestModel(
        eventName: _eventSubmissionDetails.eventName,
        profileTicket: profileModel);
  }

  getTicketTitle(int index) {
    return _eventSubmissionDetails
        .previousTicketTypeWithTotal[index].ticketType;
  }

  final _repository = Repository();
  Future<ExploreOrderResponseModel> orderTicket() async {
    final result = await _repository
        .orderTicket(jsonEncode(eventFormRequestModel.toJson()));
    return result;
  }

  @override
  void dispose() {
    if (visitorController.isNotEmpty) {
      visitorController.forEach((element) => element.dispose());
    }
    super.dispose();
  }
}
