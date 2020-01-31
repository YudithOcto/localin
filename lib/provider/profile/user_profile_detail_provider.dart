import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/dana/dana_activate_base_response.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider with ChangeNotifier {
  Repository _repository = Repository();
  StreamController<DanaAccountDetail> _danaAccountDetail;

  UserProfileProvider() {
    _danaAccountDetail = StreamController<DanaAccountDetail>.broadcast();
  }

  Future<List<ArticleDetail>> getUserArticle() async {
    final response = await _repository.getUserArticle();
    return response?.data ?? null;
  }

  Future<DanaAccountDetail> getUserDanaStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    final response = await _repository.getUserDanaStatus();
    if (response.error == null) {
      if (!_danaAccountDetail.isClosed) {
        _danaAccountDetail.add(response.data);
      }
      return response.data;
    } else {
      if (!_danaAccountDetail.isClosed) {
        _danaAccountDetail.add(null);
      }
      return null;
    }
  }

  Future<DanaActivateBaseResponse> authenticateUserDanaAccount(
      String phone) async {
    final body = {'handphone': phone};
    final result = await _repository.activateDana(FormData.fromMap(body));
    return result;
  }

  Stream<DanaAccountDetail> get danaAccountStream => _danaAccountDetail.stream;

  @override
  void dispose() {
    _danaAccountDetail.close();
    super.dispose();
  }
}
