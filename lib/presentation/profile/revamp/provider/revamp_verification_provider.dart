import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class RevampVerificationProvider with ChangeNotifier {
  File _currentUserFile;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final StreamController<bool> _sendButtonController =
      StreamController<bool>.broadcast();
  List get categoryList => _categoryList;
  String get selectedCategory => _selectedCategory;
  Stream<bool> get sendButtonState => _sendButtonController.stream;

  RevampVerificationProvider() {
    titleController..addListener(_listener);
    categoryController..addListener(_listener);
    documentController..addListener(_listener);
    categoryController.text = 'Select a category for your account';
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

  void setSelectedCategory(String value) {
    _selectedCategory = value;
    categoryController.text = value;
    notifyListeners();
  }

  List _categoryList = [
    'Music',
    'Fashion',
    'Entertainment',
    'Blogger/Influencer',
    'Others',
  ];
  String _selectedCategory = 'Music';

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
