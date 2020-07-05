import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_category.dart';

class CategoryListProvider with ChangeNotifier {
  final _repository = Repository();
  final searchController = TextEditingController();

  StreamController<categoryState> _streamController =
      StreamController<categoryState>.broadcast();
  Stream<categoryState> get categoryStream => _streamController.stream;

  List<CommunityCategory> _categoryList = List();
  List<CommunityCategory> get categoryList => _categoryList;

  bool _canCategoryLoadMore = true;
  bool get canCategoryLoadMore => _canCategoryLoadMore;

  int _pageRequest = 1;
  int get pageRequested => _pageRequest;

  CommunityCategory _selectedCategory;
  CommunityCategory get selectedCategory => _selectedCategory;
  bool isCategorySelected(CommunityCategory value) {
    if (value != null &&
        value?.categoryName == _selectedCategory?.categoryName) {
      return true;
    }
    return false;
  }

  void selectCategory(CommunityCategory value) {
    _selectedCategory = value;
    notifyListeners();
  }

  Future<Null> getCategoryList(
      {String search, bool isRefresh = true, byLocation = 0}) async {
    if (isRefresh) {
      _canCategoryLoadMore = true;
      _categoryList.clear();
      _pageRequest = 1;
    }
    if (!_canCategoryLoadMore) {
      return;
    }
    _streamController.add(categoryState.loading);
    final response = await _repository.getCategoryListCommunity(
        searchController.text, _pageRequest, byLocation);
    if (response.error == null && response.total > 0) {
      _categoryList.addAll(response.communityCategory);
      _canCategoryLoadMore = response.total > _categoryList.length;
      _pageRequest += 1;
      _streamController.add(categoryState.success);
    } else {
      _streamController.add(categoryState.empty);
      _canCategoryLoadMore = false;
    }
    notifyListeners();
  }

  set previousCategory(CommunityCategory value) {
    _selectedCategory = value;
  }

  @override
  void dispose() {
    searchController.dispose();
    _streamController.close();
    super.dispose();
  }
}

enum categoryState { loading, success, empty }
