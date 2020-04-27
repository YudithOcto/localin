import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/dana/dana_activate_base_response.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';

class UserProfileProvider with ChangeNotifier {
  Repository _repository = Repository();
  final StreamController<danaStatus> _danaAccountDetail =
      StreamController<danaStatus>.broadcast();
  DanaUserAccountResponse _userDanaAccount;

  Future<List<ArticleDetail>> getUserArticle() async {
    final response = await _repository.getUserArticle();
    return response?.data ?? null;
  }

  Future<void> getUserDanaStatus() async {
    _danaAccountDetail.add(danaStatus.Loading);
    final response = await _repository.getUserDanaStatus();
    if (response.error == null) {
      if (!_danaAccountDetail.isClosed) {
        _userDanaAccount = response;
        notifyListeners();
        _danaAccountDetail.add(danaStatus.Success);
      }
    } else {
      if (!_danaAccountDetail.isClosed) {
        _danaAccountDetail.add(danaStatus.NoData);
      }
    }
  }

  Future<DanaActivateBaseResponse> authenticateUserDanaAccount(
      String phone) async {
    final result = await _repository.activateDana(phone);
    return result;
  }

  Stream<danaStatus> get danaAccountStream => _danaAccountDetail.stream;
  DanaUserAccountResponse get userDanaAccount => _userDanaAccount;

  @override
  void dispose() {
    _danaAccountDetail.close();
    super.dispose();
  }
}

enum danaStatus { Loading, Success, NoData }
