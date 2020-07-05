import 'package:localin/model/community/community_member_detail.dart';

class CommunityMemberResponse {
  String error;
  String message;
  int total;
  List<CommunityMemberDetail> data;

  CommunityMemberResponse(
      {this.error, this.message, this.data, this.total = 0});

  factory CommunityMemberResponse.fromJson(Map<String, dynamic> body) {
    List data = body['data'];
    return CommunityMemberResponse(
      error: null,
      total: body['pagination']['total'],
      message: body['message'],
      data: data.map((value) => CommunityMemberDetail.fromJson(value)).toList(),
    );
  }

  factory CommunityMemberResponse.moderateResponse(Map<String, dynamic> body) {
    return CommunityMemberResponse(
      error: null,
      message: body['message'],
    );
  }

  CommunityMemberResponse.withError(String value)
      : error = value,
        message = value,
        data = null;
}
