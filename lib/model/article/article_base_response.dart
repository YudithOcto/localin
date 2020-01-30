import 'article_detail.dart';

class ArticleBaseResponse {
  String error;
  String message;
  int total;
  List<ArticleDetail> data;

  ArticleBaseResponse({this.error, this.message, this.total, this.data});

  factory ArticleBaseResponse.fromJson(Map<String, dynamic> body) {
    List article = body['data'];
    final pagination = body['pagination'];
    return ArticleBaseResponse(
      message: body['message'],
      error: null,
      total: pagination != null && pagination['total'] != null
          ? pagination['total']
          : null,
      data: article.map((value) => ArticleDetail.fromJson(value)).toList(),
    );
  }

  ArticleBaseResponse.withError(String error) : error = error;
}
