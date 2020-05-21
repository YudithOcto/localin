class TagModel {
  String id;
  String tagName;
  int totalArticle;

  TagModel({this.id, this.tagName, this.totalArticle});

  TagModel.fromJson(Map<String, dynamic> body)
      : id = body['id'],
        tagName = body['nilai'],
        totalArticle = body['total_artikel'] ?? 0;
}
