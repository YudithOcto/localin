import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_discover_type.dart';
import 'package:localin/model/community/community_heading_type.dart';

class LatestPostMyGroupProvider with ChangeNotifier {
  final _repository = Repository();

  final _streamController = StreamController<myGroupState>.broadcast();

  Stream<myGroupState> get state => _streamController.stream;

  List<CommunityComment> _latestPost = [];
  List<CommunityDetail> _otherCommunity = [];
  List<CommunityDiscoverType> communityType = [];

  LatestPostMyGroupProvider() {
    _streamController.add(myGroupState.loading);
    Future.wait([
      getLatestPost(),
      getOtherCommunity(),
    ]).then((value) {
      if (_latestPost.isNotEmpty) {
        communityType
            .add(CommunityHeadingType(title: 'LATEST POST IN COMMUNITIES'));
        communityType.addAll(_latestPost);
      }
      if (_otherCommunity.isNotEmpty) {
        communityType.add(CommunityHeadingType(title: 'OTHER COMMUNITIES'));
        communityType.addAll(_otherCommunity);
      }
      _streamController.add(myGroupState.success);
    });
  }

  Future<List<CommunityComment>> getLatestPost() async {
    final response = await _repository.getLatestPost(3, 1);
    if (response.error == null) {
      response.data.map((e) {
        if (e is CommunityComment) {
          _latestPost.add(e);
        }
      }).toList();
    }
    return _latestPost;
  }

  Future<List<CommunityDetail>> getOtherCommunity() async {
    final response = await _repository.getUserCommunityList();
    if (response.error == null) {
      _otherCommunity.addAll(response.communityDetailList);
    }
    return _otherCommunity;
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

enum myGroupState { loading, success, empty }
