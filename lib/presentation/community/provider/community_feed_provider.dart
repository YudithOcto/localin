import 'dart:async';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/provider/base_model_provider.dart';

class CommunityFeedProvider extends BaseModelProvider {
  final Repository _repository = Repository();
  String currentCategoryId;

  List<CommunityDetail> _userCommunityList = [];
  List<CommunityDetail> get userCommunityList => _userCommunityList;

  List<CommunityCategory> _communityCategoryList = [];
  List<CommunityCategory> get communityCategoryList => _communityCategoryList;

  @override
  void dispose() {
    super.dispose();
  }

  Future getDataFromApi() async {
    Future.wait([
      getCategoryList(),
      getUserCommunityList(),
    ]).then((value) => notifyListeners());
  }

  Future<Null> getCategoryList() async {
    final response = await _repository.getCategoryListCommunity('');
    if (response.error == null) {
      _communityCategoryList.addAll(response.communityCategory);
    }
  }

  Future<Null> getUserCommunityList({bool isRefresh = true}) async {
    final response = await _repository.getUserCommunityList();
    if (response.error == null) {
      _userCommunityList.addAll(response.communityDetailList);
    }
  }
}
