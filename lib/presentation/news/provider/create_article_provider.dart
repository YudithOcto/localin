import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/article/article_tag_response.dart';
import 'package:localin/model/article/tag_model.dart';
import 'package:localin/model/location/search_location_response.dart';

class CreateArticleProvider with ChangeNotifier {
  final Repository _repository = Repository();

  List<Uint8List> _selectedImage = [];
  List<Uint8List> get selectedImage => _selectedImage;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  CreateArticleProvider() {
    titleController
      ..addListener(() {
        if (titleController.text.isNotEmpty) {
          _isNeedAskUserToSaveToDraft = true;
          notifyListeners();
        }
      });

    captionController.addListener(() {
      if (captionController.text.isNotEmpty) {
        _isNeedAskUserToSaveToDraft = true;
        notifyListeners();
      }
    });

    searchTagController..addListener(_tagListener);
  }

  addSelectedImage(List<Uint8List> images) {
    _selectedImage.clear();
    _selectedImage.addAll(images);
    _isNeedAskUserToSaveToDraft = true;
    notifyListeners();
  }

  bool _isNeedAskUserToSaveToDraft = false;
  bool get isNeedAskUserToSaveToDraft => _isNeedAskUserToSaveToDraft;

  List<LocationResponseDetail> _selectedLocation = [];
  List<LocationResponseDetail> get selectedLocation => _selectedLocation;

  set addLocationSelected(LocationResponseDetail value) {
    _isNeedAskUserToSaveToDraft = true;
    _selectedLocation.add(value);
    notifyListeners();
  }

  Future<ArticleBaseResponse> createArticle({bool isDraft = false}) async {
    Map<String, dynamic> map = Map();
    if (_selectedImage.isNotEmpty) {
      map['gambar'] = _selectedImage
          .map((value) =>
              MultipartFile.fromBytes(value, filename: 'gambar0.jpg'))
          .toList();
      // map['gambar'] = MultipartFile.fromBytes(_selectedImage[0]);
    }
    if (_selectedTags.isNotEmpty) {
      map['tag'] = _selectedTags.map((e) => e.id).toList();
    }
    map['judul'] =
        titleController.text.isNotnullNorEmpty ? titleController.text : null;
    map['deskripsi'] = captionController.text.isNotnullNorEmpty
        ? captionController.text
        : null;
    if (_selectedLocation != null) {
      map['address'] = _selectedLocation.map((e) => e.city).toList();
    }
    if (isDraft) {
      map['is_draft'] = isDraft;
    }
    final result = await _repository.createArticle(FormData.fromMap(map));
    return result;
  }

  StreamController<searchTags> _streamController =
      StreamController<searchTags>.broadcast();
  Stream<searchTags> get streamTags => _streamController.stream;

  List<TagModel> _listTags = [];
  List<TagModel> get listTags => _listTags;

  List<TagModel> _selectedTags = [];
  List<TagModel> get selectedTags => _selectedTags;
  set addTags(TagModel model) {
    _selectedTags.add(model);
    notifyListeners();
  }

  set deleteSelectedTag(TagModel model) {
    _selectedTags.removeWhere((element) => element.id == model.id);
    notifyListeners();
  }

  final TextEditingController searchTagController = TextEditingController();

  Timer t;

  _tagListener() {
    if (t != null && t.isActive) {
      t.cancel();
      return;
    }
    if (searchTagController.text.isEmpty) {
      _listTags.clear();
      return;
    }
    t = Timer(Duration(milliseconds: 300), () async {
      getArticleTags();
    });
  }

  Future<Null> getArticleTags() async {
    _streamController.add(searchTags.loading);
    _listTags.clear();
    final result =
        await _repository.getArticleTags(searchTagController.text, 1, 3);
    if (result.error == null && result.tags != null && result.tags.isNotEmpty) {
      _listTags.addAll(result.tags);
      _streamController.add(searchTags.success);
    } else {
      _streamController.add(searchTags.empty);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

extension on String {
  bool get isNotnullNorEmpty {
    return this != null && this.isNotEmpty;
  }
}

enum searchTags { success, loading, empty }
