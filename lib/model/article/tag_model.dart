class TagModel {
  String id;
  String tagName;

  TagModel({this.id, this.tagName});

  TagModel.fromJson(Map<String, dynamic> body)
      : id = body['id'],
        tagName = body['nilai'];
}
