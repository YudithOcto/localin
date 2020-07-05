import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';

class TransactionCommunityProvider with ChangeNotifier {
  final _repository = Repository();

  final _streamController =
      StreamController<transactionCommunityState>.broadcast();
  Stream<transactionCommunityState> get transStream => _streamController.stream;

  TransactionCommunityDetail transactionDetail;
  Future<Null> getCommunityTransactionDetail(String transactionId) async {
    _streamController.add(transactionCommunityState.loading);
    final result =
        await _repository.getCommunityTransactionDetail(transactionId);
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
