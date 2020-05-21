import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class DraftArticleModel extends Equatable {
  int id;
  String title;
  String caption;
  List<String> tags;
  List<String> images;
  List<Uint8List> resultImage;
  List<String> locations;
  int dateTime;

  DraftArticleModel({
    this.id,
    this.title,
    this.caption,
    this.tags,
    this.images,
    this.resultImage,
    this.locations,
    this.dateTime,
  });

  static DraftArticleModel fromMap(Map<String, dynamic> map) {
    final image = map['images'];
    List<Uint8List> imageModel = List();
    image.map((e) => imageModel.add(Base64Decoder().convert(e))).toList();
    return DraftArticleModel(
      id: map['id'],
      title: map['title'],
      caption: map['caption'],
      tags: List<String>.from(map['tags'].map((v) => v)),
      locations: List<String>.from(map['locations'].map((v) => v)),
      resultImage: imageModel,
      dateTime: map['datetime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'caption': caption,
        'tags': tags,
        'images': images,
        'locations': locations,
        'datetime': dateTime,
      };

  @override
  List<Object> get props =>
      [id, title, caption, tags, images, locations, dateTime];
}
