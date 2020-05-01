import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/update_profile_model.dart';
import 'package:localin/model/user/user_verification_category_model.dart';

class RevampVerificationProvider with ChangeNotifier {
  File _currentUserFile;
  Repository _repository = Repository();
  List<UserCategoryDetailModel> _userCategory = List();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final StreamController<bool> _sendButtonController =
      StreamController<bool>.broadcast();
  List<UserCategoryDetailModel> get categoryList => _userCategory;
  String get selectedCategory => _selectedCategory;
  Stream<bool> get sendButtonState => _sendButtonController.stream;

  RevampVerificationProvider() {
    titleController..addListener(_listener);
    categoryController..addListener(_listener);
    documentController..addListener(_listener);
    categoryController.text = 'Select a category for your account';
    getUserCategoryModel();
  }

  _listener() {
    if (titleController.text.isNotEmpty &&
        categoryController.text.isNotEmpty &&
        documentController.text.isNotEmpty) {
      _sendButtonController.add(true);
    } else {
      _sendButtonController.add(false);
    }
    notifyListeners();
  }

  void setUserFile(File file) {
    _currentUserFile = file;
    documentController.text = 'File selected';
    notifyListeners();
  }

  Future<void> getUserCategoryModel() async {
    final response = await _repository.getUserVerificationCategory();
    if (!response.error) {
      _userCategory.addAll(response.data);
    }
  }

  Future<UpdateProfileModel> verifyUserAccount() async {
    UserCategoryDetailModel category = _userCategory
        .where((v) => v.category == _selectedCategory)
        .toList()
        .first;
    FormData _formData = FormData.fromMap({
      'photo_identitas': MultipartFile.fromFileSync(
        _currentUserFile.path,
        filename: '${_currentUserFile.path}',
      ),
      'nama': titleController.text,
      'kategori': category.id,
    });
    final response = await _repository.verifyUserAccount(_formData);
    return response;
  }

  void setSelectedCategory(String value) {
    _selectedCategory = value;
    categoryController.text = value;
    notifyListeners();
  }

  String _selectedCategory = '';

  String get validateInput {
//    return _currentUserFile != null &&
//        titleController.text != null &&
//        titleController.text.isNotEmpty &&
//        _selectedCategory.isNotEmpty;
    if (_currentUserFile == null) {
      return 'You need to attach document';
    } else if (titleController.text.isEmpty) {
      return 'You need to add field title';
    } else if (_selectedCategory.isEmpty) {
      return 'You need to select category';
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    titleController.removeListener(_listener);
    categoryController.removeListener(_listener);
    documentController.removeListener(_listener);
    titleController.dispose();
    categoryController.dispose();
    documentController.dispose();
    _sendButtonController.close();
    super.dispose();
  }
}
