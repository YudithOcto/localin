class ArticleCommentBaseResponse {
  bool error;
  String message;
  int total;
  List<ArticleCommentDetail> comments;
  ArticleCommentDetail postCommentResult;

  ArticleCommentBaseResponse(
      {this.error,
      this.message,
      this.comments,
      this.postCommentResult,
      this.total});

  factory ArticleCommentBaseResponse.fromJson(Map<String, dynamic> body) {
    List commentList = body['data'];
    return ArticleCommentBaseResponse(
      error: body['error'],
      message: body['message'],
      total: body['paging']['total'],
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
  String createdBy;
  String sender;
  String senderAvatar;
  String parentId;
  List<ArticleCommentDetail> replay = [];

  ArticleCommentDetail({
    this.commentId,
    this.articleId,
    this.comment,
    this.createdAt,
    this.sender,
    this.senderAvatar,
    this.parentId,
    this.replay,
    this.createdBy,
  });

  factory ArticleCommentDetail.fromJson(Map<String, dynamic> body) {
    return ArticleCommentDetail(
      commentId: body['koment_id'],
      articleId: body['artikel_id'],
      comment: body['komentar'],
      createdAt: body['created_at'],
      sender: body['created_name'],
      senderAvatar: body['created_avatar'],
      parentId: body['parent_id'],
      replay: body['replay'] == null
          ? []
          : List<ArticleCommentDetail>.from(
              body['replay'].map((v) => ArticleCommentDetail.fromJson(v))),
      createdBy: body['created_by'],
    );
  }
}
