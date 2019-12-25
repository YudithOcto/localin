import 'article_model.dart';

class ArticleBaseResponse {
  String error;
  String message;
  int total;
  List<ArticleModel> data;

  ArticleBaseResponse({this.error, this.message, this.total, this.data});

  factory ArticleBaseResponse.fromJson(Map<String, dynamic> body) {
    List article = body['data'];
    return ArticleBaseResponse(
      message: body['message'],
      total: body['pagination']['total'],
      data: article.map((value) => ArticleModel.fromJson(value)).toList(),
    );
  }

  ArticleBaseResponse.withError(String error) : error = error;
}
