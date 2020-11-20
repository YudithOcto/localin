import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';

class TransactionListProvider with ChangeNotifier {
  final _repository = Repository();

  bool _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  int _page = 1;

  int get page => _page;

  List<TransactionDetailModel> _listCommunityTransaction = List();

  List<TransactionDetailModel> get listCommunityTransaction =>
      _listCommunityTransaction;

  bool _isMounted = true;

  final _streamController = StreamController<transactionState>.broadcast();

  Stream<transactionState> get apiStream => _streamController.stream;

  Future<Null> getTransactionList(
      {bool isRefresh = true, @required String type}) async {
    if (isRefresh) {
      _page = 1;
      _canLoadMore = true;
      _listCommunityTransaction.clear();
    }

    final result =
        await _repository.getCommunityTransactionList(page, 10, type: type);
    if (result != null && result.total != null && result.total > 0) {
      _listCommunityTransaction.addAll(result.transactionList);
      _canLoadMore = result.total > _listCommunityTransaction.length;
      _page += 1;
      setState(transactionState.success);
    } else {
      _canLoadMore = false;
      setState(_listCommunityTransaction.isEmpty
          ? transactionState.empty
          : transactionState.success);
    }
    notifyListeners();
  }

  setState(transactionState state) {
    if (_isMounted) {
      _streamController.add(state);
    }
  }

  @override
  void dispose() {
    _streamController.close();
    _isMounted = false;
    super.dispose();
  }
}

enum transactionState { loading, success, empty }
