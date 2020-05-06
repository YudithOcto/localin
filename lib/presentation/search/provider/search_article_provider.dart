import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/article/tag_model.dart';

class SearchArticleProvider with ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  Timer _debounce;
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

  SearchArticleProvider() {
    _searchController..addListener(_onSearchChanged);
  }

  final StreamController<SearchArticleState> _articleStreamController =
      StreamController<SearchArticleState>.broadcast();
  Stream<SearchArticleState> get searchArticleStream =>
      _articleStreamController.stream;

  Future<List<ArticleDetail>> getArticle(
      {bool isRefresh = true, String keyword = ''}) async {
    _articleStreamController.add(SearchArticleState.isLoading);
    if (isRefresh) {
      _offsetPage = 1;
      _articleList.clear();
      _isCanLoadMoreArticle = true;
    }
    if (!_isCanLoadMoreArticle) {
      return null;
    }

    final response = await _repository
        .getArticleList(_offsetPage, _totalPageRequested, keyword: keyword);
    if (response != null &&
        response.data != null &&
        (_articleList.isNotEmpty || response.data.isNotEmpty)) {
      _articleList.addAll(response.data);
      _offsetPage += 1;
      _isCanLoadMoreArticle = response.total > _articleList.length;
      _articleStreamController.add(SearchArticleState.isSuccess);
    } else {
      _articleStreamController.add(SearchArticleState.isEmpty);
    }
    return response.data;
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

  Future<List<TagModel>> getTags(
      {bool isRefresh = true, String keyword = ''}) async {
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
    if (response != null &&
        response.tags != null &&
        (_tagsList.isNotEmpty || response.tags.isNotEmpty)) {
      _tagsList.addAll(response.tags);
      _offsetTags += 1;
      _isCanLoadMoreTags = response.tags.length >= _totalPageRequested;
      _tagStreamController.add(TagState.isSuccess);
    } else {
      _tagStreamController.add(TagState.isEmpty);
    }
    return response.tags;
  }

  @override
  void dispose() {
    _articleStreamController.close();
    _tagStreamController.close();
    super.dispose();
  }

  Timer t;

  _onSearchChanged() async {
    if (t != null && t.isActive) {
      t.cancel();
    }
    t = Timer(Duration(milliseconds: 1000), () {
      Future.wait([
        getArticle(keyword: _searchController.text),
        getTags(keyword: _searchController.text)
      ]).then((value) {
        notifyListeners();
      });
    });
  }
}

enum SearchArticleState { isLoading, isSuccess, isEmpty }
enum TagState { isLoading, isSuccess, isEmpty }
