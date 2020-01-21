import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';

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

  Stream<DanaAccountDetail> get danaAccountStream => _danaAccountDetail.stream;

  @override
  void dispose() {
    _danaAccountDetail.close();
    super.dispose();
  }
}
