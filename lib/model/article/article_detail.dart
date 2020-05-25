import 'package:localin/model/article/tag_model_model.dart';
import 'package:localin/model/location/search_location_response.dart';
import 'package:localin/utils/image_helper.dart';

class ArticleDetail {
  String id;
  String title;
  String slug;
  String description;
  List<MediaModel> image;
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
  List<LocationResponseDetail> location;

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
    this.location,
  });

  factory ArticleDetail.fromJson(Map<String, dynamic> body) {
    List<MediaModel> imageList = List();
    try {
      if (body['gambar'] is String) {
        imageList.add(MediaModel(attachment: body['gambar']));
      } else {
        imageList = List<MediaModel>.from(
            body['gambar'].map((v) => MediaModel.fromJson(v)));
      }
    } catch (exception) {
      print(exception);
    }
    return ArticleDetail(
      id: body['id'],
      title: body['judul'],
      slug: body['slug'],
      description: body['deskripsi'],
      image: imageList,
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
      location: body['location'] == null
          ? null
          : List<LocationResponseDetail>.from(
              body['location'].map((v) => LocationResponseDetail.fromJson(v))),
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
      attachment: body['lampiran'] == null
          ? null
          : ImageHelper.addSubFixHttp(body['lampiran']),
      type: body['tipe'],
    );
  }
}
