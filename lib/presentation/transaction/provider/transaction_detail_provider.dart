import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';

class TransactionDetailProvider with ChangeNotifier {
  final _repository = Repository();

  final _streamController =
      StreamController<transactionCommunityState>.broadcast();
  Stream<transactionCommunityState> get transStream => _streamController.stream;

  var transactionDetail;
  Future<Null> getCommunityTransactionDetail(
      String transactionId, String type) async {
    _streamController.add(transactionCommunityState.loading);
    final result = await _repository.getTransactionDetails(transactionId, type);
    if (!result.error) {
      transactionDetail = result.data;
      _streamController.add(transactionCommunityState.success);
    } else {
      _streamController.add(transactionCommunityState.empty);
    }
    notifyListeners();
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

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

enum transactionCommunityState { loading, success, empty }
