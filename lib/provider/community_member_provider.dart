import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_member_response.dart';

class CommunityMemberProvider with ChangeNotifier {
  final _repository = Repository();
  String _communityId;
  bool _isAdmin = true;
  bool get isAdmin => _isAdmin;

  CommunityMemberProvider({@required String communityId, bool isAdmin}) {
    _communityId = communityId;
    _isAdmin = isAdmin;
  }

  Future<CommunityMemberResponse> moderateSingleMember(
      {String status, String memberId}) async {
    final response =
        await _repository.moderateSingleMember(_communityId, memberId, status);
    return response;
  }

  Future<CommunityMemberResponse> moderateAllMember({String status}) async {
    final response = await _repository.moderateMember(_communityId, status);
    return response;
  }
}
