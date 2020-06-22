import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';

class TransactionCommunityProvider with ChangeNotifier {
  final _repository = Repository();

  Future<TransactionCommunityResponseModel> getCommunityTransactionDetail(
      String transactionId) async {
    return await _repository.getCommunityTransactionDetail(transactionId);
  }

  Future<TransactionCommunityResponseModel> payTransaction(
      String transactionId) async {
    return await _repository.payTransaction(transactionId);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
