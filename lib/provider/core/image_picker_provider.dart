import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localin/utils/helper_permission.dart';

class ImagePickerProvider with ChangeNotifier {
  File _userCurrentFile;
  final HelperPermission _permissionHelper = HelperPermission();

  Future<String> openCamera() async {
    final isCameraPermissionGranted =
        await _permissionHelper.getCameraPermission();
    if (isCameraPermissionGranted) {
      _userCurrentFile =
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
      _userCurrentFile =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      notifyListeners();
      return '';
    } else {
      return 'You need to grant permission for storage';
    }
  }

  Future<File> compressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60,
      minWidth: 1024,
      minHeight: 1024,
      rotate: 90,
    );
    return result;
  }

  File get selectedImage => _userCurrentFile;
}
