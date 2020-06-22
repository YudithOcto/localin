import 'dart:io';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/model/community/community_create_request_model.dart';

class CommunityCreateProvider with ChangeNotifier {
  final _repository = Repository();

  String _selectedLocation = '';
  String get selectedLocation => _selectedLocation;

  set addLocationSelected(String value) {
    _selectedLocation = value;
    notifyListeners();
  }

  CommunityCategory _selectedCategory;
  CommunityCategory get selectedCategory => _selectedCategory;
  bool isCategorySelected(CommunityCategory value) {
    if (value != null && value == _selectedCategory) {
      return true;
    }
    return false;
  }

  void selectCategory(CommunityCategory value) {
    _selectedCategory = value;
    notifyListeners();
  }

  final TextEditingController communityName = TextEditingController();
  final TextEditingController communityDescription = TextEditingController();

  File _selectedImage;
  File get selectedImage => _selectedImage;
  set selectImage(File file) {
    _selectedImage = file;
    notifyListeners();
  }

  Future<List<CommunityCategory>> getCategoryList() async {
    final response = await _repository.getCategoryListCommunity('');
    if (response.error == null) {
      return response.communityCategory;
    }
    return List();
  }

  String get isFormValid {
    if (communityName.text.isEmpty) {
      return 'Community name is required';
    } else if (communityDescription.text.isEmpty) {
      return 'Description is required';
    } else if (_selectedCategory == null) {
      return 'Please choose category';
    } else if (_selectedLocation.isEmpty) {
      return 'Please choose location';
    } else if (_selectedImage == null) {
      return 'Please set community image';
    } else {
      return '';
    }
  }

  CommunityCreateRequestModel get requestModel {
    return CommunityCreateRequestModel(
      locations: _selectedLocation,
      category: _selectedCategory,
      communityName: communityName.text,
      description: communityDescription.text,
      imageFile: _selectedImage,
    );
  }

  @override
  void dispose() {
    communityName.dispose();
    communityDescription.dispose();
    super.dispose();
  }
}
