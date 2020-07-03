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

  Future<List<CommunityDetail>> getUserCommunityList(
      {bool isRefresh = true}) async {
    final response = await _repository.getUserCommunityList();
    if (response.error == null) {
      _userCommunityList.addAll(response.communityDetailList);
    }
    return _userCommunityList;
  }
}
