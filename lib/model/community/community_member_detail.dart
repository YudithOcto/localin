class CommunityMemberDetail {
  String id;
  String name;
  String status;
  int isApproved;

  CommunityMemberDetail({this.id, this.name, this.status, this.isApproved});

  factory CommunityMemberDetail.fromJson(Map<String, dynamic> body) {
    return CommunityMemberDetail(
      id: body['id'],
      name: body['nama'],
      status: body['status'],
      isApproved: body['is_approved'],
    );
  }
}
