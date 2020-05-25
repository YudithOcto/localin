import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/draft_dao.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/darft_article_model.dart';
import 'package:localin/model/article/tag_model_model.dart';

class CreateArticleProvider with ChangeNotifier {
  final Repository _repository = Repository();
  final DraftDao _draftDao = DraftDao();

  List<Uint8List> _selectedImage = [];
  List<Uint8List> get selectedImage => _selectedImage;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  bool _isFromPublished = false;

  CreateArticleProvider(
      {DraftArticleModel previousArticleModel,
      bool isFromPublishedArticle = false}) {
    _isFromPublished = isFromPublishedArticle;

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

    if (previousArticleModel != null) {
      addDraftComponents(previousArticleModel);
    }
  }

  addDraftComponents(DraftArticleModel detail) {
    _currentDraftId = detail.id;
    titleController.text = detail?.title;
    captionController.text = detail?.caption;
    detail?.tags?.map((e) => _selectedTags.add(e))?.toList();
    detail?.resultImage?.map((e) => _selectedImage.add(e))?.toList();
    detail?.locations?.map((e) => _selectedLocation.add(e))?.toList();
  }

  bool get isShareButtonActive {
    if (titleController.text.isNotEmpty &&
        captionController.text.isNotEmpty &&
        _selectedImage.isNotEmpty &&
        _selectedTags.isNotEmpty &&
        _selectedLocation.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  String get dataChecker {
    if (titleController.text.isEmpty) {
      return 'Title is required';
    } else if (captionController.text.isEmpty) {
      return 'Caption is required';
    } else if (_selectedImage.isEmpty) {
      return 'Image is required';
    } else if (_selectedTags.isEmpty) {
      return 'Tag is required';
    } else if (_selectedLocation.isEmpty) {
      return 'Location is required';
    } else {
      return '';
    }
  }

  addSelectedImage(List<Uint8List> images) {
    _selectedImage.clear();
    _selectedImage.addAll(images);
    _isNeedAskUserToSaveToDraft = true;
    notifyListeners();
  }

  bool _isNeedAskUserToSaveToDraft = false;
  bool get isNeedAskUserToSaveToDraft => _isNeedAskUserToSaveToDraft;

  List<String> _selectedLocation = [];
  List<String> get selectedLocation => _selectedLocation;

  String _currentDraftId;

  set addLocationSelected(String value) {
    _isNeedAskUserToSaveToDraft = true;
    _selectedLocation.add(value);
    notifyListeners();
  }

  Future<int> createDraftArticle() async {
    final result = await _draftDao.insert(mappingDratModel());
    return result;
  }

  Future<ArticleBaseResponse> createArticle({bool isDraft = false}) async {
    Map<String, dynamic> map = Map();
    if (_selectedImage.isNotEmpty) {
      map['gambar'] = _selectedImage
          .map(
              (value) => MultipartFile.fromBytes(value, filename: 'gambar.jpg'))
          .toList();
    }
    if (_selectedTags.isNotEmpty) {
      map['tag'] = _selectedTags.map((tagName) => tagName).toList();
    }
    map['judul'] =
        titleController.text.isNotnullNorEmpty ? titleController.text : null;
    map['deskripsi'] = captionController.text.isNotnullNorEmpty
        ? captionController.text
        : null;
    if (_selectedLocation != null) {
      map['address'] = _selectedLocation.map((e) => e).toList();
    }
    if (isDraft) {
      map['is_draft'] = isDraft ? 1 : 0;
    }
    if (_isFromPublished) {
      map['id'] = _currentDraftId;
    }
    final result = await _repository.createArticle(FormData.fromMap(map));
    if (isDraft && result.error == null) {
      await DraftDao().delete(mappingDratModel());
    }
    return result;
  }

  DraftArticleModel mappingDratModel() {
    List<String> imageList = List();
    _selectedImage.map((e) {
      print(e.lengthInBytes);
      imageList.add(base64Encode(e));
    }).toList();
    DraftArticleModel model = DraftArticleModel(
      id: _currentDraftId,
      title: titleController.text,
      caption: captionController.text,
      images: imageList,
      tags: _selectedTags,
      locations: _selectedLocation.map((e) => e).toList(),
      dateTime: DateTime.now().millisecondsSinceEpoch,
    );
    return model;
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
