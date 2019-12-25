import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/utils/permission_helper.dart';

class CreateCommunityProvider with ChangeNotifier {
  Repository _repository = Repository();
  PermissionHelper _permissionHelper = PermissionHelper();
  File coverImageFile, logoImageFile;
  TextEditingController communityNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String category;

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
    descriptionController.dispose();
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
    String logoPath = logoImageFile?.path ?? '';
    String coverPath = coverImageFile?.path ?? '';
    FormData formData = FormData.fromMap(
      {
        'nama': communityNameController.text,
        'kategory': category,
        'deskripsi': descriptionController.text,
        'logo': MultipartFile.fromFileSync(
          logoPath,
          filename: '${communityNameController.text}logo${DateTime.now()}',
        ),
        'sampul': MultipartFile.fromFileSync(coverPath,
            filename: '${communityNameController.text}sampul${DateTime.now()}')
      },
    );
    var response;
    if (updateCommunity) {
      response = await _repository.editCommunity(formData, communityId);
    } else {
      response = await _repository.createCommunity(formData);
    }
    return response;
  }

  void setCategory(String value) {
    this.category = value;
    notifyListeners();
  }
}
