import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localin/api/draft_dao.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/article/darft_article_model.dart';

class NewsMyArticleProvider with ChangeNotifier {
  final Repository _repository = Repository();

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
  int _userArticleDraftOffset = 0;
  int get userArticleDraftOffset => _userArticleDraftOffset;
  List<DraftArticleModel> _userArticleDraftList = [];
  List<DraftArticleModel> get userArticleDraftList => _userArticleDraftList;
  final DraftDao _draftDao = DraftDao();

  bool _isCanLoadMoreDraftArticle = true;
  bool get isCanLoadMoreDraftArticle => _isCanLoadMoreDraftArticle;

  final StreamController<draftState> _controller =
      StreamController<draftState>.broadcast();
  Stream<draftState> get draftStream => _controller.stream;

  bool _isMounted = true;

  Future<List<DraftArticleModel>> getUserDraftArticle(
      {isRefresh = true}) async {
    notifyDraftState(draftState.loading);
    if (isRefresh) {
      _userArticleDraftOffset = 0;
      _userArticleDraftList.clear();
      _isCanLoadMoreDraftArticle = true;
    }

    final response = await _draftDao.getAllDraft(_userArticleDraftOffset, 10);
    if (response != null && response.isNotEmpty) {
      _userArticleDraftList.addAll(response);
      _isCanLoadMoreDraftArticle = response.length >= 10;
      notifyDraftState(draftState.success);
      notifyListeners();
      return _userArticleDraftList;
    } else {
      _isCanLoadMoreDraftArticle = false;
      if (_userArticleDraftList.isNotEmpty) {
        notifyDraftState(draftState.success);
      } else {
        notifyDraftState(draftState.empty);
      }
      return _userArticleDraftList;
    }
  }

  notifyDraftState(draftState state) {
    if (_isMounted) {
      _controller.add(state);
    }
  }

  Future<int> deleteDraftArticle(DraftArticleModel model) async {
    final DraftDao _draftDao = DraftDao();
    return await _draftDao.delete(model);
  }

  @override
  void dispose() {
    _controller.close();
    _isMounted = false;
    super.dispose();
  }
}

enum draftState { loading, success, empty }
