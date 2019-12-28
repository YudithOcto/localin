import 'package:localin/model/community/community_detail.dart';

class CommunityDetailBaseResponse {
  String error;
  String message;
  int total;
  List<CommunityDetail> communityDetail;

  CommunityDetailBaseResponse(
      {this.error, this.message, this.total, this.communityDetail});

  factory CommunityDetailBaseResponse.fromJson(Map<String, dynamic> body) {
    List detail = body['data'];
    return CommunityDetailBaseResponse(
      error: null,
      message: body['message'],
      communityDetail:
          detail.map((value) => CommunityDetail.fromJson(value)).toList(),
    );
  }

  CommunityDetailBaseResponse.hasError(String value)
      : communityDetail = List(),
        error = value;
}
