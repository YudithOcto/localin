import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/article/tag_model_model.dart';
import 'package:localin/utils/debounce.dart';

class SearchArticleProvider with ChangeNotifier {
  AnalyticsService _analyticsService;
  bool _isClearButtonVisible = false;

  bool get isClearButtonVisible => _isClearButtonVisible;

  final Repository _repository = Repository();
  final int _totalPageRequested = 10;
  int _offsetPage = 1;

  int get offsetPage => _offsetPage;

  bool _isCanLoadMoreArticle = true;

  bool get isCanLoadMoreArticle => _isCanLoadMoreArticle;

  List<ArticleDetail> _articleList = [];

  List<ArticleDetail> get articleList => _articleList;

  SearchArticleProvider({AnalyticsService analyticsService}) {
    _analyticsService = analyticsService;
  }

  final StreamController<SearchArticleState> _articleStreamController =
      StreamController<SearchArticleState>.broadcast();

  Stream<SearchArticleState> get searchArticleStream =>
      _articleStreamController.stream;

  Future<Null> getArticle({bool isRefresh = true, String keyword = ''}) async {
    if (isRefresh) {
      _offsetPage = 1;
      _articleList.clear();
      _isCanLoadMoreArticle = true;
    }
    if (!_isCanLoadMoreArticle) {
      return null;
    }
    _articleStreamController.add(SearchArticleState.isLoading);
    final response = await _repository
        .getArticleList(_offsetPage, _totalPageRequested, keyword: keyword);
    if (response.total > 0) {
      _articleList.addAll(response.data);
      _offsetPage += 1;
      _isCanLoadMoreArticle = response.total > _articleList.length;
      _articleStreamController.add(SearchArticleState.isSuccess);
    } else {
      _articleStreamController.add(SearchArticleState.isEmpty);
    }
    notifyListeners();
  }

  ///
  /// TAGS RELATED
  ///

  int _offsetTags = 1;

  int get offsetTags => _offsetTags;

  bool _isCanLoadMoreTags = true;

  bool get isCanLoadMoreTags => _isCanLoadMoreTags;

  List<TagModel> _tagsList = [];

  List<TagModel> get tagsList => _tagsList;

  final StreamController<TagState> _tagStreamController =
      StreamController<TagState>.broadcast();

  Stream<TagState> get tagStream => _tagStreamController.stream;

  Future<Null> getTags({bool isRefresh = true, String keyword = ''}) async {
    _tagStreamController.add(TagState.isLoading);
    if (isRefresh) {
      _offsetTags = 1;
      _isCanLoadMoreTags = true;
      _tagsList.clear();
    }
    if (!_isCanLoadMoreTags) {
      return null;
    }
    final response = await _repository.getArticleTags(
        keyword, _offsetTags, _totalPageRequested);
    if (response.total > 0) {
      _tagsList.addAll(response.tags);
      _offsetTags += 1;
      _isCanLoadMoreTags = response.total > _tagsList.length;
      _tagStreamController.add(TagState.isSuccess);
    } else {
      _tagStreamController.add(TagState.isEmpty);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _articleStreamController.close();
    _tagStreamController.close();
    super.dispose();
  }

  final _debounce = Debounce(milliseconds: 300);

  onSearchChanged(String v) async {
    _debounce.run(() {
      _analyticsService.setCustomSearchEvent(keyword: v);
      Future.wait([getArticle(keyword: v), getTags(keyword: v)]);
    });
  }
}

enum SearchArticleState { isLoading, isSuccess, isEmpty }
enum TagState { isLoading, isSuccess, isEmpty }
