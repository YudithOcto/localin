import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';

class HomeProvider with ChangeNotifier {
  Repository _repository = Repository();
  List<CommunityDetail> communityDetail = List();
  List<ArticleDetail> _articleDetailList = [];
  bool isRoomPage = false;
  int _pageTotal = 0;
  final int _limitPageRequest = 8;
  int _pageRequest = 1;
  bool _canLoadMore = true;
  StreamController<articleState> _articleController =
      StreamController<articleState>.broadcast();

  Future<CommunityDetailBaseResponse> getCommunityList(String search) async {
    final response = await _repository.getCommunityList(search);
    if (response != null) {
      communityDetail.clear();
      communityDetail.addAll(response.communityDetailList);
    }
    return response;
  }

  Future<List<ArticleDetail>> getArticleList({bool isRefresh = true}) async {
    if (isRefresh) {
      _articleDetailList.clear();
      _pageRequest = 1;
      _canLoadMore = true;
      _pageTotal = 0;
    }
    if (!_canLoadMore) {
      return null;
    }
    _articleController.add(articleState.Loading);
    final response = await _repository.getArticleList(
        _pageRequest, _limitPageRequest,
        isBookmark: null, isLiked: null);
    if (response != null && response.error != 'success') {
      _articleController.add(articleState.Success);
      _articleDetailList.addAll(response.data);
      _pageTotal = response.total;
      _canLoadMore = _pageTotal > _articleDetailList.length;
      _pageRequest += 1;
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

  @override
  void dispose() {
    _articleController.close();
    super.dispose();
  }

  List<ArticleDetail> get articleDetailList => _articleDetailList;
  Stream<articleState> get articleStream => _articleController.stream;
  bool get canLoadMore => _canLoadMore;
}

enum articleState { Loading, Success, NoData }
