import 'package:localin/model/article/tag_model.dart';

class ArticleTagResponse {
  bool search;
  String keyword;
  String error;
  List<TagModel> tags;

  ArticleTagResponse({this.search, this.keyword, this.tags});

  factory ArticleTagResponse.fromJson(Map<String, dynamic> body) {
    List data = body['data'];
    return ArticleTagResponse(
      search: body['search'],
      keyword: body['keyword'],
      tags: data != null && data.isNotEmpty
          ? data.map((value) => TagModel.fromJson(value)).toList()
          : null,
    );
  }

  ArticleTagResponse.withError(String value)
      : error = value,
        tags = null;
}
