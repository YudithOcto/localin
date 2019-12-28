import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_base_response_category.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/provider/base_model_provider.dart';

class CommunityFeedProvider extends BaseModelProvider {
  CommunityBaseResponseCategory categoryList;
  CommunityDetailBaseResponse communityDetail;
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

  void setLoadingSearching(bool value) {
    isSearchLoading = value;
    notifyListeners();
  }
}
