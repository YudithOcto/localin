import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_tag_response.dart';
import 'package:localin/model/article/tag_model.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/utils/helper_permission.dart';

class CreateArticleProvider extends BaseModelProvider {
  Repository _repository = Repository();
  HelperPermission _permissionHelper = HelperPermission();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  File attachmentImage;
  ArticleTagResponse tagResponse;
  TagModel userChosenTag;
  bool autoValidate = false;
  Address address;

  @override
  void dispose() {
    locationController.dispose();
    titleController.dispose();
    contentController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Future<String> getImageFromCamera() async {
    var result = await _permissionHelper.openCamera();
    if (result != null) {
      attachmentImage = result;
      notifyListeners();
      return '';
    }
    return 'You need to grant permission for camera';
  }

  Future<String> getImageFromStorage() async {
    var result = await _permissionHelper.openGallery();
    if (result != null) {
      attachmentImage = result;
      notifyListeners();
      return '';
    }
    return 'You need to grant permission for storage';
  }

  Future<ArticleTagResponse> getArticleTags(String keyword) async {
    var result = await _repository.getArticleTags(keyword, 1, null);
    if (result != null && result.error == null) {
      tagResponse = result;
      notifyListeners();
    }
    return result;
  }

  bool validateInput() {
    var form = formKey.currentState;
    if (form.validate() && attachmentImage != null) {
      form.save();
      return true;
    } else {
      autoValidate = true;
      notifyListeners();
      return false;
    }
  }

  Future<ArticleBaseResponse> createArticle() async {
    setState(ViewState.Busy);
    String attachmentPath =
        attachmentImage != null ? attachmentImage.path : null;
    FormData formData = FormData.fromMap(
      {
        'judul': titleController.text != null && titleController.text.isNotEmpty
            ? titleController.text
            : null,
        'deskripsi':
            contentController.text != null && contentController.text.isNotEmpty
                ? contentController.text
                : null,
        'gambar': attachmentPath != null && attachmentPath.isNotEmpty
            ? MultipartFile.fromFileSync(
                attachmentPath,
                filename: '$attachmentPath}',
              )
            : null,
        'tag[]': tagsController.text != null && tagsController.text.isNotEmpty
            ? tagsController.text
            : null,
        'lat': address?.coordinates?.latitude,
        'long': address?.coordinates?.longitude,
        'address': '${address.locality}, ${address.subAdminArea}',
      },
    );
    var result = await _repository.createArticle(formData);
    if (result != null) {
      setState(ViewState.Idle);
    }
    return result;
  }

  void setChosenTag(TagModel model) {
    this.userChosenTag = model;
    this.tagsController.text = model.tagName;
    notifyListeners();
  }

  void setAddress(Address value) {
    this.address = value;
    notifyListeners();
  }
}
