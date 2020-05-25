import 'dart:async';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/provider/base_model_provider.dart';

class CommunityFeedProvider extends BaseModelProvider {
  int currentQuickPicked = 0;
  bool isSearchLoading = false;
  Repository _repository = Repository();
  String currentCategoryId;

  List<CommunityDetail> _userCommunityList = [];
  List<CommunityDetail> get userCommunityList => _userCommunityList;

  List<CommunityCategory> _communityCategoryList = [];
  List<CommunityCategory> get communityCategoryList => _communityCategoryList;

  Future getCommunityData() async {
    return Future.wait(
        [getCategoryList(), getCategoryList(), getCommunityList()]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCategoryList() async {
    final response = await _repository.getCategoryListCommunity('');
    _communityCategoryList.addAll(response.communityCategory);
  }

  Future<void> getUserCommunityList({bool isRefresh = true}) async {
    final response = await _repository.getUserCommunityList();
    _userCommunityList.addAll(response.communityDetailList);
  }

  int _offset = 1;
  int get offset => _offset;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  int _limit = 10;
  List<CommunityDetail> _communityNearbyList = [];
  List<CommunityDetail> get communityNearbyList => _communityNearbyList;

  Future<void> getCommunityList({bool isRefresh = true}) async {
    if (isRefresh) {
      _offset = 1;
      _canLoadMore = true;
    }
    final response = await _repository.getCommunityList(
        keyword: '', page: _offset, limit: _limit);
    if (response.communityDetailList.isNotEmpty) {
      _communityNearbyList.addAll(response?.communityDetailList);
      _offset += 1;
      _canLoadMore = response.total > _communityNearbyList.length;
      notifyListeners();
    }
    return response;
  }

//  Future<CommunityDetailBaseResponse> searchCommunityBaseCategory(
//      String categoryId) async {
//    setLoadingSearching(true);
//    final response = await _repository.getCommunityListByCategory(categoryId);
//    if (response != null) {
//      communityDetail = response;
//      setLoadingSearching(false);
//      notifyListeners();
//    }
//    return response;
//  }
//
//  Future<CommunityDetailBaseResponse> joinCommunity(String communityId) async {
//    final response = await _repository.joinCommunity(communityId);
//    var result;
//    if (response != null) {
//      if (currentCategoryId != null && currentQuickPicked > 0) {
//        result = await searchCommunityBaseCategory(currentCategoryId);
//      }
//    }
//    return result;
//  }

  void setLoadingSearching(bool value) {
    isSearchLoading = value;
    notifyListeners();
  }

  void setCurrentQuickPicked(int index, String categoryId) {
    this.currentQuickPicked = index;
    this.currentCategoryId = categoryId;
    notifyListeners();
  }
}
