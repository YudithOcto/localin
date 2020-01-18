class ArticleCommentBaseResponse {
  bool error;
  String message;
  List<ArticleCommentDetail> comments;
  ArticleCommentDetail postCommentResult;

  ArticleCommentBaseResponse(
      {this.error, this.message, this.comments, this.postCommentResult});

  factory ArticleCommentBaseResponse.fromJson(Map<String, dynamic> body) {
    List commentList = body['data'];
    return ArticleCommentBaseResponse(
      error: body['error'],
      message: body['message'],
      comments: commentList
          .map((value) => ArticleCommentDetail.fromJson(value))
          .toList(),
    );
  }

  ArticleCommentBaseResponse.publishResponse(Map<String, dynamic> body)
      : postCommentResult = ArticleCommentDetail.fromJson(body['data']),
        error = body['error'],
        message = body['message'];

  ArticleCommentBaseResponse.withError(String value)
      : error = true,
        message = value,
        comments = null;
}

class ArticleCommentDetail {
  String commentId;
  String articleId;
  String comment;
  String createdAt;
  String sender;

  ArticleCommentDetail(
      {this.commentId,
      this.articleId,
      this.comment,
      this.createdAt,
      this.sender});

  factory ArticleCommentDetail.fromJson(Map<String, dynamic> body) {
    return ArticleCommentDetail(
      commentId: body['koment_id'],
      articleId: body['artikel_id'],
      comment: body['komentar'],
      createdAt: body['created_at'],
      sender: body['created_name'],
    );
  }
}
