import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';
import 'package:localin/presentation/profile/user_profile/provider/user_profile_detail_provider.dart';

class HomeProvider with ChangeNotifier {
  Repository _repository = Repository();
  List<CommunityDetail> communityDetail = List();
  List<ArticleDetail> _articleDetailList = List();
  bool isRoomPage = false;
  final int _limitPageRequest = 10;
  int _pageRequest = 1;
  StreamController<articleState> _articleController =
      StreamController<articleState>.broadcast();

  Future<CommunityDetailBaseResponse> getCommunityList(String search) async {
    final response = await _repository.getCommunityList(keyword: search);
    if (response != null) {
      communityDetail.clear();
      communityDetail.addAll(response.communityDetailList);
    }
    return response;
  }

  Future<List<ArticleDetail>> getArticleList({bool isRefresh = true}) async {
    if (isRefresh) {
      _articleDetailList.clear();
    }

    _articleController.add(articleState.Loading);
    final response = await _repository.getArticleList(
        _pageRequest, _limitPageRequest,
        isBookmark: null, isLiked: null);
    if (response != null && response.error != 'success') {
      _articleController.add(articleState.Success);
      _articleDetailList.addAll(response.data);
    } else {
      _articleController.add(articleState.NoData);
    }
    notifyListeners();
    return response.data;
  }

  Future<ArticleBaseResponse> likeArticle(String articleId) async {
    final response = await _repository.likeArticle(articleId);
    return response;
  }

  Future<ArticleBaseResponse> bookmarkArticle(String articleId) async {
    final response = await _repository.bookmarkArticle(articleId);
    return response;
  }

  Future<DanaUserAccountResponse> getDanaStatus() async {
    return await _repository.getUserDanaStatus();
  }

  void setRoomPage(bool value) {
    this.isRoomPage = value;
    notifyListeners();
  }

  Future<DanaUserAccountResponse> getUserDanaStatus() async {
    return await _repository.getUserDanaStatus();
  }

  @override
  void dispose() {
    _articleController.close();
    super.dispose();
  }

  List<ArticleDetail> get articleDetailList => _articleDetailList;
  Stream<articleState> get articleStream => _articleController.stream;
}

enum articleState { Loading, Success, NoData }
enum danaState { loading, success, empty }
