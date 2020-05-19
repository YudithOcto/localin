import 'package:localin/model/article/tag_model.dart';

class ArticleDetail {
  String id;
  String title;
  String slug;
  String description;
  String image;
  String createdAt;
  String createdBy;
  String updatedAt;
  String author;
  String authorImage;
  String type;
  List<TagModel> tags;
  int isLike;
  int isBookmark;
  int totalLike;
  int totalComment;
  List<MediaModel> media;

  ArticleDetail({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.author,
    this.authorImage,
    this.type,
    this.tags,
    this.isLike,
    this.isBookmark,
    this.createdBy,
    this.totalLike,
    this.totalComment,
    this.media,
  });

  factory ArticleDetail.fromJson(Map<String, dynamic> body) {
    return ArticleDetail(
      id: body['id'],
      title: body['judul'],
      slug: body['slug'],
      description: body['deskripsi'],
      image: body['gambar'],
      createdAt: body['created_at'],
      createdBy: body['created_by'],
      updatedAt: body['updated_at'],
      author: body['penulis'],
      authorImage: body['penulis_avatar'],
      type: body['type'],
      tags: body['tags'] == null
          ? []
          : List<TagModel>.from(body['tags'].map((x) => TagModel.fromJson(x))),
      isBookmark: body['is_bookmark'],
      isLike: body['is_like'],
      totalLike: body['total_like'],
      totalComment: body['total_komentar'],
      media: body['media'] == null
          ? []
          : List<MediaModel>.from(
              body['media'].map((x) => MediaModel.fromJson(x))),
    );
  }
}

class MediaModel {
  String attachmentId;
  String type;
  String attachment;

  MediaModel({this.attachment, this.type, this.attachmentId});

  factory MediaModel.fromJson(Map<String, dynamic> body) {
    return MediaModel(
      attachmentId: body['lampiran_id'],
      attachment: body['lampiran'],
      type: body['tipe'],
    );
  }
}
