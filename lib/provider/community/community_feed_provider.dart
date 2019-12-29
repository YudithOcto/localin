import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_base_response_category.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/provider/base_model_provider.dart';

class CommunityFeedProvider extends BaseModelProvider {
  CommunityBaseResponseCategory categoryList;
  CommunityDetailBaseResponse communityDetail;
  int currentQuickPicked = 0;
  bool isSearchLoading = false;
  Repository _repository = Repository();
  TextEditingController searchController = TextEditingController();
  Timer _debounce;

  CommunityFeedProvider() {
    setState(ViewState.Busy);
    Future.wait([getCategoryList(), getCommunityList()]).then((value) {
      setState(ViewState.Idle);
    });
    searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      searchCommunity(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController?.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<CommunityBaseResponseCategory> getCategoryList() async {
    final response = await _repository.getCategoryListCommunity('');
    if (response != null && response.message != null) {
      categoryList = response;
      CommunityCategory category = CommunityCategory();
      category.categoryName = 'all';
      categoryList.communityCategory.insert(0, category);
    }
    return response;
  }

  Future<CommunityDetailBaseResponse> getCommunityList() async {
    final response = await _repository.getCommunityList('');
    if (response != null && response.message != null) {
      communityDetail = response;
    }
    return response;
  }

  Future<CommunityDetailBaseResponse> searchCommunity(String search) async {
    setLoadingSearching(true);
    final response = await _repository.getCommunityList(search);
    if (response != null && response.message != null) {
      communityDetail = response;
      setLoadingSearching(false);
      notifyListeners();
    }
    return response;
  }

  Future<CommunityDetailBaseResponse> searchCommunityBaseCategory(
      String categoryId) async {
    setLoadingSearching(true);
    final response = await _repository.getCommunityListByCategory(categoryId);
    if (response != null) {
      communityDetail = response;
      setLoadingSearching(false);
      notifyListeners();
    }
    return response;
  }

  void setLoadingSearching(bool value) {
    isSearchLoading = value;
    notifyListeners();
  }

  void setCurrentQuickPicked(int index) {
    this.currentQuickPicked = index;
    notifyListeners();
  }
}
