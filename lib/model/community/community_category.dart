class CommunityCategory {
  String id;
  String categoryName;
  String type;
  String sort;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int isPublic;

  CommunityCategory(
      {this.id,
      this.categoryName,
      this.type,
      this.sort,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.isPublic});

  factory CommunityCategory.fromJson(Map<String, dynamic> body) {
    return CommunityCategory(
      id: body['id'],
      categoryName: body['nilai'],
      type: body['group'],
      sort: body['sort'],
      createdAt: body['created_at'],
      updatedAt: body['updated_at'],
      deletedAt: body['deleted_at'],
      isPublic: body['is_public'],
    );
  }
}
