import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';

class CommunityDetailProvider with ChangeNotifier {
  CommunityDetail communityDetail;
  bool isSearchMemberPage = false;

  CommunityDetailProvider({this.communityDetail});

  void setSearchMemberPage(bool value) {
    this.isSearchMemberPage = value;
    notifyListeners();
  }
}
