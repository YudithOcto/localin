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
  });

  factory ArticleDetail.fromJson(Map<String, dynamic> body) {
    List tags = body['tags'];
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
      tags: tags.map((value) => TagModel.fromJson(value)).toList(),
      isBookmark: body['is_bookmark'],
      isLike: body['is_like'],
      totalLike: body['total_like'],
      totalComment: body['total_komentar'],
    );
  }
}
