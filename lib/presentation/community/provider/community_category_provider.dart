import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_category.dart';

class CommunityCategoryProvider with ChangeNotifier {
  final Repository _repository = Repository();

  Future<List<CommunityCategory>> getCommunityCategory() async {
    final result = await _repository.getCategoryListCommunity('');
    if (result.error == null) {
      return result.communityCategory;
    } else {
      return List();
    }
  }
}
