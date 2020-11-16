import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/tag_model_model.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/presentation/news/provider/create_article_provider.dart';

class CommunityCreatePostProvider with ChangeNotifier {
  List<Uint8List> _selectedImage = [];

  List<Uint8List> get selectedImage => _selectedImage;

  addSelectedImage(List<Uint8List> images) {
    _selectedImage.clear();
    _selectedImage.addAll(images);
    notifyListeners();
  }

  StreamController<searchTags> _streamController =
      StreamController<searchTags>.broadcast();

  Stream<searchTags> get streamTags => _streamController.stream;

  List<TagModel> _listTags = [];

  List<TagModel> get listTags => _listTags;

  void clearListTags() {
    _listTags.clear();
    notifyListeners();
  }

  List<String> _selectedTags = [];

  List<String> get selectedTags => _selectedTags;

  set addTags(String tagName) {
    _selectedTags.add(tagName);
    notifyListeners();
  }

  set deleteSelectedTag(String name) {
    _selectedTags.removeWhere((element) => element == name);
    notifyListeners();
  }

  final TextEditingController searchTagController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  final _repository = Repository();

  Future<CommunityCommentBaseResponse> addPost(String communityId) async {
    Map<String, dynamic> map = Map();
    if (_selectedImage.isNotEmpty) {
      map['tipe'] = 'gambar';
      map['lampiran'] = _selectedImage
          .map(
              (value) => MultipartFile.fromBytes(value, filename: 'gambar.jpg'))
          .toList();
    } else {
      map['tipe'] = 'kosong';
    }
    if (_selectedTags.isNotEmpty) {
      map['tag'] = _selectedTags.map((tagName) => tagName).toList();
    }
    map['text'] = captionController.text.isNotnullNorEmpty
        ? captionController.text
        : null;

    final result = await _repository.createPostCommunity(
        FormData.fromMap(map), communityId);
    return result;
  }

  String get isButtonActive {
    if (_selectedTags.isEmpty) {
      return 'Tag is required';
    } else if (captionController.text.isEmpty) {
      return 'Caption is required';
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    _streamController.close();
    captionController.dispose();
    searchTagController.dispose();
    super.dispose();
  }
}

extension on String {
  bool get isNotnullNorEmpty {
    return this != null && this.isNotEmpty;
  }
}
