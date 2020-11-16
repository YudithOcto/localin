class CommunityEventMemberResponse {
  CommunityEventMemberResponse(
      {this.error, this.message, this.memberList, this.total});

  bool error;
  String message;
  int total;
  List<EventMemberDetail> memberList;

  factory CommunityEventMemberResponse.fromJson(Map<String, dynamic> map) {
    return CommunityEventMemberResponse(
      error: false,
      message: map['message'],
      total: map['data']['pagination']['total'],
      memberList: List<EventMemberDetail>.from(
          map['data']['data'].map((e) => EventMemberDetail.fromJson(e))),
    );
  }

  CommunityEventMemberResponse.withError(String value)
      : error = true,
        message = value,
        total = 0,
        memberList = List();
}

class EventMemberDetail {
  String memberId;
  DateTime joinDate;
  String memberName;
  String memberImage;
  String communityJoinType;
  bool verifiedUser;

  EventMemberDetail({
    this.memberId,
    this.joinDate,
    this.memberName,
    this.memberImage,
    this.communityJoinType,
    this.verifiedUser,
  });

  factory EventMemberDetail.fromJson(Map<String, dynamic> map) {
    return EventMemberDetail(
        memberId: map['member_id'],
        joinDate: DateTime.parse(map['join_at']),
        memberName: map['member_name'] ?? '',
        memberImage: map['member_image'],
        communityJoinType: map['status_join_komunitas'],
        verifiedUser: map['verified'] == null
            ? null
            : map['verified'] == 1
                ? true
                : false);
  }
}
