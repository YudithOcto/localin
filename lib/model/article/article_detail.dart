import 'package:localin/model/article/tag_model.dart';

class ArticleDetail {
  String title;
  String slug;
  String description;
  String image;
  String createdAt;
  String updatedAt;
  String author;
  String authorImage;
  List<TagModel> tags;

  ArticleDetail(
      {this.title,
      this.slug,
      this.description,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.author,
      this.authorImage,
      this.tags});

  factory ArticleDetail.fromJson(Map<String, dynamic> body) {
    List tags = body['tags'];
    return ArticleDetail(
      title: body['judul'],
      slug: body['slug'],
      description: body['deskripsi'],
      image: body['gambar'],
      createdAt: body['created_at'],
      updatedAt: body['updated_at'],
      author: body['penulis'],
      authorImage: body['penulis_avatar'],
      tags: tags.map((value) => TagModel.fromJson(value)).toList(),
    );
  }
}
