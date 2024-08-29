import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/transaction/transaction_discount_response_model.dart';

class TransactionDiscountProvider with ChangeNotifier {
  TransactionDiscountProvider(int price)
      : assert(price != null),
        _price = price;

  int _price;

  final couponController = TextEditingController();

  bool _isUseLocalPoint = false;

  bool get isUseLocalPoint => _isUseLocalPoint;

  void switchLocalPointUsage() {
    _isUseLocalPoint = !_isUseLocalPoint;
    notifyListeners();
  }

  final _repository = Repository();

  Future<TransactionDiscountResponseModel> getTransactionDiscount() async {
    final form = FormData.fromMap({
      'kupon': couponController.text,
      'use_poin': _isUseLocalPoint ? 1 : 0,
      'harga': _price,
    });
    final response = await _repository.getTransactionDiscount(form);
    return response;
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }
}
