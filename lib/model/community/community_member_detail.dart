class CommunityMemberDetail {
  String id;
  String name;
  String status;
  int isApproved;
  String imageProfile;
  bool isVerified;
  String joinedDate;
  String addedBy;

  CommunityMemberDetail({
    this.id,
    this.name,
    this.status,
    this.isApproved,
    this.imageProfile,
    this.isVerified,
    this.joinedDate,
    this.addedBy,
  });

  factory CommunityMemberDetail.fromJson(Map<String, dynamic> body) {
    return CommunityMemberDetail(
      id: body['id'],
      name: body['nama'],
      status: body['status'],
      isApproved: body['is_approved'],
      imageProfile: body['image_profile'],
      isVerified: body['verified_identitas'],
      joinedDate: body['start_join'],
      addedBy: body['added_by'],
    );
  }
}
