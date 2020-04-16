import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_detail.dart';

class HomeProvider with ChangeNotifier {
  Repository _repository = Repository();
  List<CommunityDetail> communityDetail = List();
  List<ArticleDetail> articleDetail = [];
  bool isRoomPage = false;
  String previewUrl = '';
  int total = 0;
  final int pageSize = 8;
  int pageOffset = 1;
  int counter = 1;
  bool isLoading = false;
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

  Future<List<ArticleDetail>> resetAndGetArticleList() async {
    this.counter = 1;
    articleDetail = [];
    return getArticleList();
  }

  Future<List<ArticleDetail>> getArticleList(
      {bool isRefresh = true, int offset = 0}) async {
    if (isRefresh) {
      articleDetail.clear();
      pageOffset = 1;
    }
    _articleController.add(articleState.Loading);
    final response = await _repository.getArticleList(offset, pageSize);
//    if (response != null && response.data != null && response.data.isNotEmpty) {
//      articleDetail.addAll(response.data);
//      total = response.total;
//      _articleController.add(articleState.Loading);
//      counter += 1;
//    } else {
//      _articleController.add(articleState.Loading);
//      articleDetail = null;
//    }
    if (response != null && response.error != 'success') {
      _articleController.add(articleState.Success);
      articleDetail.addAll(response.data);
      total = response.total;
      pageOffset += 1;
      notifyListeners();
    } else {
      _articleController.add(articleState.NoData);
    }
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

  void setRoomPage(bool value) {
    this.isRoomPage = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _articleController.close();
    super.dispose();
  }

  Stream<articleState> get articleStream => _articleController.stream;
}

enum articleState { Loading, Success, NoData }
