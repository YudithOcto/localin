import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_detail.dart';

class HomeProvider with ChangeNotifier {
  Repository _repository = Repository();
  List<CommunityDetail> communityDetail = List();
  List<ArticleDetail> articleDetail = List();
  bool isRoomPage = false;
  String previewUrl = '';

  Future<CommunityDetailBaseResponse> getCommunityList(String search) async {
    var response = await _repository.getCommunityList(search);
    if (response != null) {
      communityDetail.clear();
      communityDetail.addAll(response.communityDetailList);
    }
    return response;
  }

  Future<List<ArticleDetail>> getArticleList(int offset, int limit) async {
    var response = await _repository.getArticleList(limit, offset);
    return response.data;
  }

  void setRoomPage(bool value) {
    this.isRoomPage = value;
    notifyListeners();
  }
}
