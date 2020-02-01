class EventCategory {
  bool error;
  String message;
  List<CategoryEventDetail> data;

  EventCategory({this.error, this.message, this.data});

  factory EventCategory.fromJson(Map<String, dynamic> body) {
    List eventList = body['data'];
    return EventCategory(
      error: body['error'],
      message: body['message'],
      data: eventList
          .map((value) => CategoryEventDetail.fromJson(value))
          .toList(),
    );
  }

  EventCategory.withError(String value)
      : error = true,
        message = value,
        data = null;
}

class CategoryEventDetail {
  String id;
  String categoryName;
  String group;
  String sort;
  String createdAt;
  String updatedAt;
  int isPublic;
  String groupSub;

  CategoryEventDetail(
      {this.id,
      this.categoryName,
      this.group,
      this.sort,
      this.createdAt,
      this.updatedAt,
      this.isPublic,
      this.groupSub});

  factory CategoryEventDetail.fromJson(Map<String, dynamic> body) {
    return CategoryEventDetail(
        id: body['id'],
        categoryName: body['nilai'],
        group: body['group'],
        sort: body['sort'],
        createdAt: body['created_at'],
        updatedAt: body['updated_at'],
        isPublic: body['is_public'],
        groupSub: body['group_sub']);
  }
}
