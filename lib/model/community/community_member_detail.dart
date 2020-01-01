class CommunityMemberDetail {
  String id;
  String name;
  String status;
  int isApproved;
  String imageProfile;

  CommunityMemberDetail(
      {this.id, this.name, this.status, this.isApproved, this.imageProfile});

  factory CommunityMemberDetail.fromJson(Map<String, dynamic> body) {
    return CommunityMemberDetail(
      id: body['id'],
      name: body['nama'],
      status: body['status'],
      isApproved: body['is_approved'],
      imageProfile: body['image_profile'],
    );
  }
}
