import 'community_comment_base_response.dart';

class CommunityMyGroupResponse {
  String message;
  int total;
  String error;
  List data;

  CommunityMyGroupResponse({this.message, this.total, this.error, this.data});

  factory CommunityMyGroupResponse.withJson(Map<String, dynamic> map) {
    List dta = map['data'];
    return CommunityMyGroupResponse(
        message: map['message'],
        total: map['paging']['total'],
        error: null,
        data: map['data'] == null
            ? null
            : dta.map((e) => CommunityComment.fromJson(e)).toList());
  }
  CommunityMyGroupResponse.withError(String value)
      : error = value,
        data = [];
}
