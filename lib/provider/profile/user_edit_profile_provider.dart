import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localin/api/api_constant.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/utils/helper_permission.dart';

class UserEditProfileProvider with ChangeNotifier {
  bool cameraStatus, storageStatus;
  HelperPermission _permissionHelper = HelperPermission();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController shortBioController = TextEditingController();
  TextEditingController idCardController = TextEditingController();
  StreamController<String> controller = StreamController<String>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  File imageFile, idFile;
  bool isProfileNeedUpdate = false;
  UserModel user;
  String progress;
  Repository _repository = Repository();

  UserEditProfileProvider({UserModel model}) {
    this.user = model;
    if (user != null) {
      displayNameController.text = user.username;
      shortBioController.text = user.shortBio;
    }
  }

  @override
  void dispose() {
    super.dispose();
    shortBioController.dispose();
    displayNameController.dispose();
    idCardController.dispose();
    controller.close();
  }

  Future<String> openCamera(bool verify) async {
    //request runtime permission first
    var isCameraPermissionGranted =
        await _permissionHelper.getCameraPermission();
    if (isCameraPermissionGranted) {
      isProfileNeedUpdate = true;
      if (verify) {
        idFile = await ImagePicker.pickImage(source: ImageSource.camera);
        if (idFile != null) notifyListeners();
      } else {
        imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
        if (imageFile != null) notifyListeners();
      }
      return '';
    } else {
      return 'You need to grant permission for camera';
    }
  }

  Future<String> openGallery(bool verify) async {
    var isStoragePermissionGranted =
        await _permissionHelper.getStoragePermission();
    if (isStoragePermissionGranted) {
      isProfileNeedUpdate = true;
      if (verify) {
        idFile = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (idFile != null) notifyListeners();
      } else {
        imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (imageFile != null) notifyListeners();
      }
      return '';
    } else {
      return 'You need to grant permission for storage';
    }
  }

  Future<String> updateProfileData() async {
    Dio dio = Dio();
    String imagePath = imageFile?.path ?? '';
    FormData formData = FormData.fromMap({
      'photo_profile': imagePath.isNotEmpty
          ? MultipartFile.fromFileSync(imagePath,
              filename: '${user.username}photo${DateTime.now()}.')
          : null,
      'nama': displayNameController.text,
      'short_bio': shortBioController.text,
    });
    var header = {
      'Authorization': 'Bearer ${user.apiToken}',
    };
    Options options = Options(headers: header, contentType: 'application/json');
    await dio.post('${ApiConstant.kBaseUrl}${ApiConstant.kUpdateProfile}',
        options: options, data: formData, onSendProgress: (send, total) {
      progress = ((send / total) * 100).toStringAsFixed(0) + '%';
      notifyListeners();
    });
    return progress;
  }

  Future<UserModel> updateNewProfileData() async {
    var response = await _repository.getUserProfile();
    return response;
  }

  clearChangedFile() {
    this.imageFile = null;
    this.isProfileNeedUpdate = false;
    this.idFile = null;
    notifyListeners();
  }

  bool validateInput() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      autoValidate = true;
      notifyListeners();
      return false;
    }
  }

  Future<String> verifyAccount() async {
    Dio dio = Dio();
    String imagePath = idFile?.path ?? '';
    FormData formData = FormData.fromMap({
      'photo_identitas': imagePath.isNotEmpty
          ? MultipartFile.fromFileSync(imagePath,
              filename: '${user.username}photo${DateTime.now()}')
          : null,
      'nomor': idCardController.text,
    });
    var header = {
      'Authorization': 'Bearer ${user.apiToken}',
    };
    Options options = Options(headers: header, contentType: 'application/json');
    await dio.post('${ApiConstant.kBaseUrl}${ApiConstant.kVerifyAccount}',
        options: options, data: formData, onSendProgress: (send, total) {
      progress = ((send / total) * 100).toStringAsFixed(0) + '%';
      notifyListeners();
    });
    return progress;
  }
}
