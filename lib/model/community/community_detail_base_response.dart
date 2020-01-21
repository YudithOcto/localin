import 'package:localin/model/community/community_detail.dart';

class CommunityDetailBaseResponse {
  String error;
  String message;
  int total;
  List<CommunityDetail> communityDetailList;
  CommunityDetail detailCommunity;

  CommunityDetailBaseResponse(
      {this.error, this.message, this.total, this.communityDetailList});

  factory CommunityDetailBaseResponse.fromJson(Map<String, dynamic> body) {
    List detail = body['data'];
    return CommunityDetailBaseResponse(
      error: null,
      message: body['message'],
      communityDetailList:
          detail.map((value) => CommunityDetail.fromJson(value)).toList(),
    );
  }

  CommunityDetailBaseResponse.mapJsonCommunityDetail(Map<String, dynamic> body)
      : communityDetailList = List(),
        message = body['message'],
        detailCommunity = CommunityDetail.fromJson(body['data']),
        error = null;

  CommunityDetailBaseResponse.uploadSuccess(String value)
      : communityDetailList = List(),
        message = value,
        error = null;

  CommunityDetailBaseResponse.hasError(String value)
      : communityDetailList = List(),
        error = value;
}
