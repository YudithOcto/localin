import 'article_detail.dart';

class ArticleBaseResponse {
  String error;
  String message;
  int total;
  List<ArticleDetail> data;

  ArticleBaseResponse({this.error, this.message, this.total, this.data});

  factory ArticleBaseResponse.fromJson(Map<String, dynamic> body) {
    List article = body['data'];
    return ArticleBaseResponse(
      message: body['message'],
      total: body['pagination']['total'] ?? null,
      data: article.map((value) => ArticleDetail.fromJson(value)).toList(),
    );
  }

  ArticleBaseResponse.withError(String error) : error = error;
}
