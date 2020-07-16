import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_response_model.dart';
import 'package:localin/model/explore/submit_form_request_model.dart';

class SubmitConfirmationOrderProvider with ChangeNotifier {
  final _repository = Repository();
  Future<ExploreOrderResponseModel> orderTicket(
      SubmitFormRequestModel model) async {
    final result = await _repository.orderTicket(jsonEncode(model.toJson()));
    return result;
  }
}
