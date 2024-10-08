import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/draft_dao.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
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

  final StreamController<archiveState> _archiveController =
      StreamController<archiveState>.broadcast();

  Stream<archiveState> get archiveStream => _archiveController.stream;

  Future<Null> getUserTrashArticle({isRefresh = true}) async {
    setArchiveState(archiveState.loading);
    if (isRefresh) {
      _userArticleArchiveOffset = 1;
      _userArticleArchiveList.clear();
      _canLoadMoreArticleArchiveList = true;
    }

    final response = await _repository.getUserArticle(
        offset: _userArticleArchiveOffset, isTrash: 1);
    if (response != null && response.total > 0) {
      _userArticleArchiveList.addAll(response.data);
      _userArticleArchiveOffset += 1;
      _canLoadMoreArticleArchiveList =
          response.total > _userArticleArchiveList.length;
      setArchiveState(archiveState.success);
      notifyListeners();
    } else {
      setArchiveState(_userArticleArchiveList.isNotEmpty
          ? archiveState.success
          : archiveState.empty);
      _canLoadMoreArticleArchiveList = false;
    }
  }

  setArchiveState(archiveState state) {
    if (_isMounted) {
      _archiveController.add(state);
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

  Future<ArticleBaseResponse> unarchiveArticle(String slug) async {
    return await _repository.unarchiveArticle(slug);
  }

  @override
  void dispose() {
    _controller.close();
    _archiveController.close();
    _isMounted = false;
    super.dispose();
  }
}

enum draftState { loading, success, empty }
enum archiveState { loading, success, empty }
