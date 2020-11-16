import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/user/user_model.dart';

class RevampOthersProvider with ChangeNotifier {
  final Repository _repository = Repository();
  bool _canLoadMoreArticle = true;
  List<ArticleDetail> _articleList = [];

  int _articleTotal = 0, _pageRequest = 0, _pageLimit = 10;
  final StreamController<OthersProfileState> _stateController =
      StreamController<OthersProfileState>.broadcast();

  Stream<OthersProfileState> get articleStream => _stateController.stream;

  List<ArticleDetail> get articleList => _articleList;

  bool get canLoadMoreArticle => _canLoadMoreArticle;

  Future<ArticleBaseResponse> getArticleList(
      {bool isRefresh = true, @required String id}) async {
    if (isRefresh) {
      _articleList.clear();
      _pageRequest = 1;
      _canLoadMoreArticle = true;
      _articleTotal = 0;
    }
    if (!_canLoadMoreArticle) {
      return null;
    }
    _stateController.add(OthersProfileState.Loading);
    final response =
        await _repository.getOtherArticle(_pageRequest, _pageLimit, id);
    if (response != null && response.error == null) {
      _stateController.add(OthersProfileState.Success);
      _articleList.addAll(response.data);
      _articleTotal = response.total;
      _canLoadMoreArticle = _articleTotal > _articleList.length;
      _pageRequest += 1;
    } else {
      _stateController.add(OthersProfileState.NoData);
    }
    notifyListeners();
    return response;
  }

  Future<UserModel> getOtherUserProfile(String profileId) async {
    final response = await _repository.getOtherUserProfile(profileId);
    return response;
  }

  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }
}

enum OthersProfileState { Loading, Success, NoData }
