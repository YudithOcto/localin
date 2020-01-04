import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_tag_response.dart';
import 'package:localin/model/article/tag_model.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/utils/helper_permission.dart';

class CreateArticleProvider extends BaseModelProvider {
  Repository _repository = Repository();
  HelperPermission _permissionHelper = HelperPermission();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  File attachmentImage;
  ArticleTagResponse tagResponse;
  TagModel userChosenTag;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Future<String> getImageFromCamera() async {
    var result = await _permissionHelper.openCamera();
    if (result != null) {
      attachmentImage = result;
      return '';
    }
    return 'You need to grant permission for camera';
  }

  Future<String> getImageFromStorage() async {
    var result = await _permissionHelper.openGallery();
    if (result != null) {
      attachmentImage = result;
      return '';
    }
    return 'You need to grant permission for storage';
  }

  Future<ArticleTagResponse> getArticleTags(String keyword) async {
    var result = await _repository.getArticleTags(keyword);
    if (result != null && result.error == null) {
      tagResponse = result;
      notifyListeners();
    }
    return result;
  }

  void setChosenTag(TagModel model) {
    this.userChosenTag = model;
    this.tagsController.text = model.tagName;
    notifyListeners();
  }
}
