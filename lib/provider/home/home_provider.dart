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
  List<ArticleDetail> articleDetail = List();
  bool isRoomPage = false;
  String previewUrl = '';
  int total = 0;
  final int pageSize = 3;
  int counter = 1;
  bool isLoading = true;

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

  Future<List<ArticleDetail>> getArticleList() async {
    isLoading = true;
    final response = await _repository.getArticleList(counter, pageSize);
    if (response != null && response.data != null && response.data.isNotEmpty) {
      articleDetail.addAll(response.data);
      total = response.total;
      counter += 1;
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      articleDetail = null;
      notifyListeners();
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
}
