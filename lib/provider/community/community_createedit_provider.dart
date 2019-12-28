import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/utils/helper_permission.dart';

class CommunityCreateEditProvider with ChangeNotifier {
  Repository _repository = Repository();
  HelperPermission _permissionHelper = HelperPermission();
  File coverImageFile, logoImageFile;
  TextEditingController communityNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  FocusNode focusNode = FocusNode();
  CommunityCategory category = CommunityCategory();
  bool loading = false;

  @override
  void dispose() {
    communityNameController.dispose();
    descriptionController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<String> openCamera(bool isIcon) async {
    //request runtime permission first
    var isCameraPermissionGranted =
        await _permissionHelper.getCameraPermission();
    if (isCameraPermissionGranted) {
      if (isIcon) {
        logoImageFile = await ImagePicker.pickImage(source: ImageSource.camera);
        if (logoImageFile != null) notifyListeners();
      } else {
        coverImageFile =
            await ImagePicker.pickImage(source: ImageSource.camera);
        if (coverImageFile != null) notifyListeners();
      }
      return '';
    } else {
      return 'You need to grant permission for camera';
    }
  }

  Future<String> openGallery(bool isIcon) async {
    var isStoragePermissionGranted =
        await _permissionHelper.getStoragePermission();
    if (isStoragePermissionGranted) {
      if (isIcon) {
        logoImageFile =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        if (logoImageFile != null) notifyListeners();
      } else {
        coverImageFile =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        if (coverImageFile != null) notifyListeners();
      }
      return '';
    } else {
      return 'You need to grant permission for storage';
    }
  }

  Future<CommunityDetailBaseResponse> createCommunity(bool updateCommunity,
      {String communityId}) async {
    setLoading(true);
    String logoPath = logoImageFile?.path ?? '';
    String coverPath = coverImageFile?.path ?? '';
    FormData formData = FormData.fromMap(
      {
        'nama': communityNameController.text,
        'kategory': category.id,
        'deskripsi': descriptionController.text,
        'logo': logoPath.isEmpty
            ? null
            : MultipartFile.fromFileSync(
                logoPath,
                filename:
                    '${communityNameController.text}logo${DateTime.now()}',
              ),
        'sampul': coverPath.isNotEmpty
            ? MultipartFile.fromFileSync(coverPath,
                filename:
                    '${communityNameController.text}sampul${DateTime.now()}')
            : null
      },
    );
    var response;
    if (updateCommunity) {
      response = await _repository.editCommunity(formData, communityId);
      setLoading(false);
    } else {
      response = await _repository.createCommunity(formData);
      setLoading(false);
    }
    return response;
  }

  void setAutoValidate(bool value) {
    this.autoValidate = value;
    notifyListeners();
  }

  bool validateInput() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      setAutoValidate(true);
      return false;
    }
  }

  void setCategory(CommunityCategory value) {
    categoryController.text = value.categoryName;
    this.category = value;
    notifyListeners();
  }

  void setLoading(bool loading) {
    this.loading = loading;
    notifyListeners();
  }
}
