import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';

class NewsArticleProvider with ChangeNotifier {
  final Repository _apiRepository = Repository();

  List<ArticleDetail> _articleList = [];
  List<ArticleDetail> get articleList => _articleList;

  int _pageRequest = 1, _limitPageRequest = 10;
  int get pageRequest => _pageRequest;
  bool _canLoadMore = true;
  bool get canLoadMoreArticle => _canLoadMore;
  int _pageTotal = 0;

  StreamController<NewsArticleState> _articleLoadController =
      StreamController<NewsArticleState>.broadcast();
  Stream<NewsArticleState> get streamArticle => _articleLoadController.stream;

  Future<List<ArticleDetail>> getArticleList({
    bool isRefresh = true,
    int isLiked,
    int isBookmark,
  }) async {
    if (isRefresh) {
      _articleList.clear();
      _pageRequest = 1;
      _canLoadMore = true;
      _pageTotal = 0;
      isLiked = isLiked;
      isBookmark = isBookmark;
    }
    if (!_canLoadMore) {
      return null;
    }

    _articleLoadController.add(NewsArticleState.Loading);
    final response = await _apiRepository.getArticleList(
        _pageRequest, _limitPageRequest,
        isBookmark: isBookmark, isLiked: isLiked);
    if (response != null &&
        response.data != null &&
        (response.data.isNotEmpty || _articleList.isNotEmpty)) {
      _articleLoadController.add(NewsArticleState.Success);
      _articleList.addAll(response.data);
      _pageTotal = response.total;
      _canLoadMore = _pageTotal > _articleList.length;
      _pageRequest += 1;
    } else {
      _canLoadMore = false;
      _articleLoadController.add(NewsArticleState.NoData);
    }
    notifyListeners();
    return _articleList;
  }

  void reAddBookmark(ArticleDetail articleDetail, int index) {
    _articleList.insert(index, articleDetail);
    notifyListeners();
  }

  /// GET BOOKMARK ARTICLE
  List<ArticleDetail> get bookmarkArticleList {
    if (_articleList != null && _articleList.isNotEmpty) {
      return _articleList.where((article) => article.isBookmark == 1).toList();
    }
    return [];
  }

  /// GET LIKED ARTICLE
  List<ArticleDetail> get likedArticleList {
    if (_articleList != null && _articleList.isNotEmpty) {
      return _articleList.where((article) => article.isLike == 1).toList();
    }
    return [];
  }

  @override
  void dispose() {
    _articleLoadController.close();
    super.dispose();
  }
}

enum NewsArticleState { Loading, Success, NoData }
