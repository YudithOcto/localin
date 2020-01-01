abstract class MemberListItem {}

class HeadingItem extends MemberListItem {
  String title;
  HeadingItem({this.title});
}

class AdminItem extends MemberListItem {
  String title;
  String imageProfile;
  AdminItem({this.title, this.imageProfile});
}

class MemberItem extends MemberListItem {
  String title;
  String id;
  String status;
  int isApproved;
  String imageProfile;
  MemberItem(
      {this.title, this.id, this.status, this.isApproved, this.imageProfile});
}
