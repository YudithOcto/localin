class CommunityCommentBaseResponse {
  String error;
  int total;
  List<CommunityComment> data;
  String message;
  CommunityComment commentResult;

  CommunityCommentBaseResponse(
      {this.error, this.total, this.data, this.message, this.commentResult});

  factory CommunityCommentBaseResponse.fromJson(Map<String, dynamic> body) {
    List commentList = body['data'];
    return CommunityCommentBaseResponse(
      error: null,
      total: body['pagination'] != null ? body['pagination']['total'] : 0,
      message: body['message'],
      data: commentList
          .map((comment) => CommunityComment.fromJson(comment))
          .toList(),
    );
  }

  CommunityCommentBaseResponse.withError(String value)
      : error = value,
        message = null,
        data = null;

  CommunityCommentBaseResponse.addComment(Map<String, dynamic> body)
      : message = body['message'],
        commentResult = body['data'],
        error = null;
}

class CommunityComment {
  CommunityComment(
      {this.id,
      this.commentContent,
      this.status,
      this.createdBy,
      this.publishedBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.attachment,
      this.type,
      this.parentId,
      this.childComment});

  String id;
  String commentContent;
  String status;
  String createdBy;
  String publishedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String attachment;
  String type;
  String parentId;
  int childComment;

  factory CommunityComment.fromJson(Map<String, dynamic> body) {
    return CommunityComment(
      id: body['komunitas_id'],
      commentContent: body['komentar'],
      status: body['status'],
      createdBy: body['created_by'],
      publishedBy: body['terbit_by'],
      createdAt: body['created_at'],
      updatedAt: body['updated_at'],
      deletedAt: body['deleted_at'],
      attachment: body['lampiran'],
      type: body['tipe'],
      parentId: body['parent_id'],
      childComment: body['komentar_child'],
    );
  }
}
