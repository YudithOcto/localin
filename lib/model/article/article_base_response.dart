import 'article_detail.dart';

class ArticleBaseResponse {
  String error;
  String message;
  int total;
  List<ArticleDetail> data;
  ArticleDetail detail;

  ArticleBaseResponse({this.error, this.message, this.total, this.data});

  factory ArticleBaseResponse.fromJson(Map<String, dynamic> body) {
    List article = body['data'];
    final pagination = body['pagination'];
    return ArticleBaseResponse(
      message: body['message'],
      error: null,
      total: pagination != null && pagination['total'] != null
          ? pagination['total']
          : 0,
      data: article.map((value) => ArticleDetail.fromJson(value)).toList(),
    );
  }

  ArticleBaseResponse.withJson(Map<String, dynamic> body)
      : error = null,
        message = body['message'],
        detail = ArticleDetail.fromJson(body['data']);

  ArticleBaseResponse.withError(String error) : error = error;
}
