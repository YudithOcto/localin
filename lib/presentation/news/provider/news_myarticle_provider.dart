import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';

class NewsMyArticleProvider with ChangeNotifier {
  final Repository _repository = Repository();

  /// USER ARTICLE
  int _userArticleOffset = 1;
  int get userArticleOffset => _userArticleOffset;
  List<ArticleDetail> _userArticleList = [];
  List<ArticleDetail> get userArticleList => _userArticleList;

  bool _canLoadMoreArticleList = true;
  bool get canLoadMoreArticleList => _canLoadMoreArticleList;

  Future<List<ArticleDetail>> getUserArticle({isRefresh = true}) async {
    if (isRefresh) {
      _userArticleOffset = 1;
      _userArticleList.clear();
      _canLoadMoreArticleList = true;
    }

    final response =
        await _repository.getUserArticle(offset: _userArticleOffset);
    if (response != null && response.error == null) {
      _userArticleList.addAll(response.data);
      _userArticleOffset += 1;
      _canLoadMoreArticleList = response.total > _userArticleList.length;
      notifyListeners();
      return _userArticleList;
    } else {
      _canLoadMoreArticleList = false;
      return _userArticleList;
    }
  }

  /// USER TRASH ARTICLE
  int _userArticleArchiveOffset = 1;
  int get userArticleArchiveOffset => _userArticleArchiveOffset;

  List<ArticleDetail> _userArticleArchiveList = [];
  List<ArticleDetail> get userArticleArchiveList => _userArticleArchiveList;

  bool _canLoadMoreArticleArchiveList = true;
  bool get canLoadMoreArchiveArticleList => _canLoadMoreArticleArchiveList;

  Future<List<ArticleDetail>> getUserTrashArticle({isRefresh = true}) async {
    if (isRefresh) {
      _userArticleArchiveOffset = 1;
      _userArticleArchiveList.clear();
      _canLoadMoreArticleArchiveList = true;
    }

    final response = await _repository.getUserArticle(
        offset: _userArticleArchiveOffset, isTrash: 1);
    if (response != null && response.error == null) {
      _userArticleArchiveList.addAll(response.data);
      _userArticleArchiveOffset += 1;
      _canLoadMoreArticleArchiveList =
          response.total > _userArticleArchiveList.length;
      notifyListeners();
      return _userArticleArchiveList;
    } else {
      _canLoadMoreArticleArchiveList = false;
      return _userArticleArchiveList;
    }
  }

  /// USER DRAFT ARTICLE
  int _userArticleDraftOffset = 1;
  int get userArticleDraftOffset => _userArticleDraftOffset;
  List<ArticleDetail> _userArticleDraftList = [];
  List<ArticleDetail> get userArticleDraftList => _userArticleDraftList;

  bool _isCanLoadMoreDraftArticle = true;
  bool get isCanLoadMoreDraftArticle => _isCanLoadMoreDraftArticle;

  Future<List<ArticleDetail>> getUserDraftArticle({isRefresh = true}) async {
    if (isRefresh) {
      _userArticleDraftOffset = 1;
      _userArticleDraftList.clear();
      _isCanLoadMoreDraftArticle = true;
    }

    final response = await _repository.getUserArticle(
        offset: _userArticleDraftOffset, isDraft: 1);
    if (response != null && response.error == null) {
      _userArticleDraftList.addAll(response.data);
      _userArticleDraftOffset += 1;
      _isCanLoadMoreDraftArticle =
          response.total > _userArticleDraftList.length;
      notifyListeners();
      return _userArticleDraftList;
    } else {
      _isCanLoadMoreDraftArticle = false;
      return _userArticleDraftList;
    }
  }
}
