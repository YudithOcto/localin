import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/utils/helper_permission.dart';

class RevampEditProfileProvider with ChangeNotifier {
  final HelperPermission _permissionHelper = HelperPermission();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController shortBioController = TextEditingController();
  File _userPictureFile;
  UserModel _userModel;
  bool _isProfileNeedUpdate = false;
  Repository _repository = Repository();

  RevampEditProfileProvider({UserModel model}) {
    this._userModel = model;
    if (_userModel != null) {
      displayNameController.text = _userModel.username;
      shortBioController.text = _userModel.shortBio;
    }
  }

  Future<String> openCamera() async {
    final isCameraPermissionGranted =
        await _permissionHelper.getCameraPermission();
    if (isCameraPermissionGranted) {
      _isProfileNeedUpdate = true;
      _userPictureFile =
          await ImagePicker.pickImage(source: ImageSource.camera);
      notifyListeners();
      return '';
    } else {
      return 'You need to grant permission for camera';
    }
  }

  Future<String> openGallery() async {
    final isStoragePermissionGranted =
        await _permissionHelper.getStoragePermission();
    if (isStoragePermissionGranted) {
      _isProfileNeedUpdate = true;
      _userPictureFile =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      notifyListeners();
      return '';
    } else {
      return 'You need to grant permission for storage';
    }
  }

  Future<UserModel> refreshUserProfileData() async {
    return await _repository.getUserProfile();
  }

  Future<String> saveAndUpdateUserProfile() async {
    Map<String, dynamic> inputMap = Map();
    inputMap.addAll({
      'nama': displayNameController.text,
      'short_bio': shortBioController.text,
    });

    if (_userPictureFile != null) {
      final tempDir = await path_provider.getTemporaryDirectory();
      final targetPath = tempDir.absolute.path + "/temp.jpg";
      final imgFile = await compressAndGetFile(
          _userPictureFile != null ? _userPictureFile : null, targetPath);
      inputMap['photo_profile'] = MultipartFile.fromFileSync(imgFile.path,
          filename: '${_userModel.username}photo${DateTime.now()}');
    }

    FormData _formData = FormData.fromMap(inputMap);
    final response = await _repository.updateUserProfile(_formData);
    return response;
  }

  Future<File> compressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
      minWidth: 1024,
      minHeight: 1024,
      rotate: 90,
    );
    return result;
  }

  bool get isProfileNeedUpdate => _isProfileNeedUpdate;
  File get userImageFile => _userPictureFile;

  @override
  void dispose() {
    displayNameController.dispose();
    shortBioController.dispose();
    super.dispose();
  }
}
