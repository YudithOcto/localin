import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/community/community_discover_type.dart';
import 'package:localin/presentation/community/community_create/community_type_page.dart';

class CommunityCommentBaseResponse {
  String error;
  int total;
  List<CommunityComment> data;
  String message;
  CommunityComment commentResult;

  CommunityCommentBaseResponse(
      {this.error, this.total, this.data, this.message, this.commentResult});

  factory CommunityCommentBaseResponse.fromJson(Map<String, dynamic> body) {
    return CommunityCommentBaseResponse(
      error: null,
      total: body['pagination'] != null ? body['pagination']['total'] : 0,
      message: body['message'],
      data: body['data'] == null
          ? []
          : List<CommunityComment>.from(
              body['data'].map((v) => CommunityComment.fromJson(v))),
    );
  }

  CommunityCommentBaseResponse.withError(String value)
      : error = value,
        message = null,
        data = [];

  CommunityCommentBaseResponse.addComment(Map<String, dynamic> body)
      : message = body['message'],
        commentResult = CommunityComment.fromJson(body['data']),
        error = null;
}

class CommunityComment implements CommunityDiscoverType {
  CommunityComment({
    this.id,
    this.communityId,
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
    this.childComment,
    this.childCommentList,
    this.createdName,
    this.createdAvatar,
    this.communityName,
    this.communityLogo,
    this.communityTotalMember,
    this.communityCategoryId,
    this.communityCategoryName,
    this.isLike,
    this.totalLike,
  });

  int id;
  String communityId;
  String commentContent;
  String status;
  String createdBy;
  String createdName;
  String createdAvatar;
  String publishedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  List<MediaModel> attachment;
  List<CommunityComment> childCommentList;
  String type;
  String parentId;
  int childComment;
  String communityName;
  String communityLogo;
  int communityTotalMember;
  String communityCategoryId;
  String communityCategoryName;
  bool isLike;
  int totalLike;

  factory CommunityComment.fromJson(Map<String, dynamic> body) {
    return CommunityComment(
      id: body['id'],
      communityId: body['komunitas_id'],
      commentContent: body['komentar'],
      status: body['status'],
      createdBy: body['created_by'],
      publishedBy: body['terbit_by'],
      createdAt: body['created_at'],
      updatedAt: body['updated_at'],
      deletedAt: body['deleted_at'],
      attachment: body['lampiran'] == null
          ? []
          : List<MediaModel>.from(
              body['lampiran'].map((e) => MediaModel.fromJson(e))),
      childCommentList: body['data'] == null
          ? []
          : List<CommunityComment>.from(
              body['data'].map((v) => CommunityComment.fromJson(v))),
      type: body['tipe'],
      parentId: body['parent_id'].toString(),
      childComment: body['komentar_child'] ?? 0,
      createdAvatar: body['created_avatar'] ?? '',
      createdName: body['created_name'],
      communityLogo: body['komunitas_logo'] ?? null,
      communityName: body['komunitas_name'] ?? null,
      communityTotalMember: body['komunitas_total_member'] ?? null,
      communityCategoryId: body['komunitas_kategori'] ?? null,
      communityCategoryName: body['komunitas_kategori_name'] ?? null,
      isLike:
          body['is_like'] == null ? false : body['is_like'] == 1 ? true : false,
      totalLike: body['total_like'] == null ? 0 : body['total_like'],
    );
  }
}
