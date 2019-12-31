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
  MemberItem({this.title});
}
