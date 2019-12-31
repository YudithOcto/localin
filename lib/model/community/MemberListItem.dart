abstract class MemberListItem {}

class HeadingItem extends MemberListItem {
  String title;
  HeadingItem({this.title});
}

class AdminItem extends MemberListItem {
  String title;
  AdminItem({this.title});
}

class MemberItem extends MemberListItem {
  String title;
  String id;
  String status;
  int isApproved;
  MemberItem({this.title, this.id, this.status, this.isApproved});
}
