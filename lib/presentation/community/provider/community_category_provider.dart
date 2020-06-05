import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/model/community/community_detail_base_response.dart';

class CommunityCategoryProvider with ChangeNotifier {
  final _repository = Repository();

  Future<List<CommunityCategory>> getCommunityCategory() async {
    final result = await _repository.getCategoryListCommunity('');
    if (result.error == null) {
      return result.communityCategory;
    } else {
      return List();
    }
  }

  Future<CommunityDetailBaseResponse> getPopularCommunity(
      {String categoryId}) async {
    final result = await _repository.getPopularCommunity(
        limit: 10, offset: 0, categoryId: categoryId);
    return result;
  }
}
