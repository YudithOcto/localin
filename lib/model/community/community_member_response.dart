import 'package:localin/model/community/community_member_detail.dart';

class CommunityMemberResponse {
  String error;
  String message;
  List<CommunityMemberDetail> data;

  CommunityMemberResponse({this.error, this.message, this.data});

  factory CommunityMemberResponse.fromJson(Map<String, dynamic> body) {
    List data = body['data'];
    return CommunityMemberResponse(
      error: null,
      message: body['message'],
      data: data.map((value) => CommunityMemberDetail.fromJson(value)).toList(),
    );
  }

  CommunityMemberResponse.withError(String value)
      : error = value,
        message = null,
        data = null;
}
