import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_event_submission_details.dart';
import 'package:localin/model/explore/explore_response_model.dart';
import 'package:localin/model/explore/single_person_form_model.dart';
import 'package:localin/model/explore/submit_form_request_model.dart';
import 'package:localin/model/transaction/discount_status.dart';
import 'package:localin/model/transaction/transaction_discount_response_model.dart';
import 'package:localin/utils/number_helper.dart';

class SubmitFormProvider with ChangeNotifier {
  ExploreEventSubmissionDetails _eventSubmissionDetails;

  ExploreEventSubmissionDetails get eventSubmissionDetails =>
      _eventSubmissionDetails;

  SubmitFormProvider(
      ExploreEventSubmissionDetails details, String currentUserName) {
    _eventSubmissionDetails = details;
    _eventSubmissionDetails.previousTicketTypeWithTotal
        .asMap()
        .forEach((index, value) {
      visitorController
          .add(TextEditingController(text: index == 0 ? currentUserName : ''));
    });
    getAdminFee(_eventSubmissionDetails.totalTicket,
        _eventSubmissionDetails.totalPrice);
  }

  get singlePaxPrice {
    return 'Pax (${_eventSubmissionDetails.totalTicket}) @${_eventSubmissionDetails.totalPrice == 0 ? 'Free' : getFormattedCurrency(_eventSubmissionDetails.totalPrice)}';
  }

  List<TextEditingController> visitorController = [];

  get totalSelectedTicket {
    return _eventSubmissionDetails.previousTicketTypeWithTotal.length;
  }

  bool get isButtonNotActive {
    if (formKey.currentState.validate()) {
      return false;
    } else {
      autoValidate = true;
      notifyListeners();
      return true;
    }
  }

  get eventFormPersonNam {
    List<SinglePersonFormModel> person = [];
    _eventSubmissionDetails.previousTicketTypeWithTotal
        .asMap()
        .forEach((index, value) {
      person.add(SinglePersonFormModel(
        ticketType: value.ticketType,
        name: visitorController[index].text,
      ));
    });
    return person;
  }

  SubmitFormRequestModel get eventFormRequestModel {
    List<SubmitProfileTicketModel> profileModel = [];
    Map<int, List<String>> _items = Map();

    _eventSubmissionDetails.previousTicketTypeWithTotal
        .asMap()
        .forEach((index, ticket) {
      if (_items.containsKey(ticket.idTicket)) {
        final item = _items[ticket.idTicket];
        item.add(visitorController[index].text);
      } else {
        List<String> names = [visitorController[index].text];
        _items.putIfAbsent(ticket.idTicket, () => names);
      }
    });

    _items.forEach((key, value) {
      profileModel.add(SubmitProfileTicketModel(
        idTicket: key,
        visitorNames: value,
      ));
    });

    return SubmitFormRequestModel(
        eventName: _eventSubmissionDetails.eventName,
        profileTicket: profileModel,
        coupon: _couponParams,
        usePoint: _localPoint);
  }

  getTicketTitle(int index) {
    return _eventSubmissionDetails
        .previousTicketTypeWithTotal[index].ticketType;
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;

  final _repository = Repository();

  Future<ExploreOrderResponseModel> orderTicket() async {
    final result = await _repository
        .orderTicket(jsonEncode(eventFormRequestModel.toJson()));
    return result;
  }

  getAdminFee(int qty, int totalPrice) async {
    final response = await _repository.getAdminFee(FormData.fromMap({
      'harga': totalPrice,
      'qty': qty,
    }));
    if (!response.isError) {
      adminFee = response.adminFare;
    }
    notifyListeners();
  }

  int adminFee = 0;

  PriceData _priceData;
  set addPriceData(PriceData data) {
    this._priceData = data;
    _eventSubmissionDetails.totalPrice = data.userPrice;
    notifyListeners();
  }

  DiscountStatus _appliedDiscountParams = DiscountStatus();
  String get _couponParams => _appliedDiscountParams.couponValue != null &&
          _appliedDiscountParams.couponValue.isNotEmpty
      ? _appliedDiscountParams.couponValue
      : '';
  int get _localPoint => _appliedDiscountParams.isUsingLocalPoint != null
      ? _appliedDiscountParams.isUsingLocalPoint
      : 0;
  set addParamsDiscount(DiscountStatus status) {
    _appliedDiscountParams = status;
    notifyListeners();
  }

  int get couponDiscount => _priceData != null ? _priceData.couponDiscount : 0;
  int get localPointDiscount =>
      _priceData != null ? _priceData.pointDiscount : 0;
  bool get isCouponActive =>
      _priceData != null && _priceData.couponDiscount > 0;
  bool get isLocalPointActive =>
      _priceData != null && _priceData.pointDiscount > 0;

  @override
  void dispose() {
    if (visitorController.isNotEmpty) {
      visitorController.forEach((element) => element.dispose());
    }
    super.dispose();
  }
}
