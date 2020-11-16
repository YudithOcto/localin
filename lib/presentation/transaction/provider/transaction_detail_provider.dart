import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';
import 'package:localin/model/transaction/transaction_discount_response_model.dart';
import 'package:localin/model/transaction/transaction_explore_detail_response.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';
import 'package:localin/utils/constants.dart';

class TransactionDetailProvider with ChangeNotifier {
  final _repository = Repository();

  final _streamController =
      StreamController<transactionDetailState>.broadcast();

  Stream<transactionDetailState> get transStream => _streamController.stream;

  var transactionDetail;

  Future<Null> getTransactionDetail(String transactionId, String type) async {
    _streamController.add(transactionDetailState.loading);
    final result = await _repository.getTransactionDetails(transactionId, type);
    if (!result.error) {
      transactionDetail = result.data;
      _streamController.add(transactionDetailState.success);
    } else {
      _streamController.add(transactionDetailState.empty);
    }
    notifyListeners();
  }

  updateTransactionDetail(String type, String status) {
    if (type == kTransactionTypeExplore) {
      final tempData = transactionDetail as Data;
      tempData.status = status;
      transactionDetail = tempData;
    } else if (type == kTransactionTypeCommunity) {
      final tempData = transactionDetail as TransactionDetailModel;
      tempData.status = status;
    }
    navigateRefresh = true;
  }

  Future<BookingPaymentResponse> payTransaction(String transactionId) async {
    return await _repository.payTransaction(transactionId);
  }

  set status(String value) {
    transactionDetail.status = value;
    notifyListeners();
  }

  Future<String> cancelTransaction(String transactionId) async {
    return await _repository.cancelTransaction(transactionId);
  }

  bool _isNavigateBackNeedRefresh = false;

  bool get isNavigateBackNeedRefresh => _isNavigateBackNeedRefresh;

  set navigateRefresh(bool value) {
    _isNavigateBackNeedRefresh = value;
    notifyListeners();
  }

  PriceData priceData;
  set addPriceData(PriceData value) {
    priceData = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

enum transactionDetailState { loading, success, empty }
