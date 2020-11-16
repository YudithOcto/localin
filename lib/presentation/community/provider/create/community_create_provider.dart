import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/model/community/community_create_request_model.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/utils/image_helper.dart';

class CommunityCreateProvider with ChangeNotifier {
  final _repository = Repository();
  List<String> _selectedLocation = List();

  List<String> get selectedLocation => _selectedLocation;

  final _streamController = StreamController<createState>.broadcast();

  Stream<createState> get stream => _streamController.stream;

  bool _isEditCommunity = false;
  CommunityDetail _previousCommunityDetail;

  Future<Null> addPreviousCommunityData(CommunityDetail model) async {
    _streamController.add(createState.loading);
    if (model != null) {
      final data = await ImageHelper.urlToFile(model.logo);
      communityName.text = model.name;
      communityDescription.text = model.description;
      model.address.forEach((element) {
        selectedLocation.add(element);
      });
      _selectedCategory = CommunityCategory(
          categoryName: model.categoryName, id: model.category);
      _selectedImage = data;
      _streamController.add(createState.success);
      _isEditCommunity = true;
      _previousCommunityDetail = model;
    } else {
      _streamController.add(createState.noPreviousData);
    }
    notifyListeners();
  }

  void addLocationSelected(String value,
      {bool isEdit = false, int position = 0}) {
    if (isEdit) {
      _selectedLocation[position] = value;
    } else {
      _selectedLocation.add(value);
    }
    notifyListeners();
  }

  CommunityCategory _selectedCategory;

  bool isCategorySelected(CommunityCategory value) {
    if (value != null &&
        value?.categoryName == _selectedCategory?.categoryName) {
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
      communityId: _previousCommunityDetail?.id,
      category: _selectedCategory,
      communityName: communityName.text,
      description: communityDescription?.text,
      imageFile: _selectedImage,
      isEditMode: _isEditCommunity,
    );
  }

  Future<CommunityDetailBaseResponse> createEditCommunity(
      {CommunityCreateRequestModel model}) async {
    Map<String, dynamic> map = Map();
    map['nama'] = model.communityName;
    map['deskripsi'] = model.description;
    map['address'] = model.locations.map((e) => e).toList();
    map['type'] = _previousCommunityDetail.communityType;
    map['kategori'] = model.category.id;
    map['logo'] = MultipartFile.fromFileSync(model.imageFile.path,
        filename: model.imageFile.path);
    CommunityDetailBaseResponse response;
    FormData _formApi = FormData.fromMap(map);
    response = await _repository.editCommunity(_formApi, model.communityId);
    return response;
  }

  @override
  void dispose() {
    communityName.dispose();
    communityDescription.dispose();
    _streamController.close();
    super.dispose();
  }
}

enum createState { loading, success, noPreviousData }
