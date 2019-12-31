import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HelperPermission {
  Future<bool> checkPermission() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    return permission == PermissionStatus.granted;
  }

  Future<bool> getStoragePermission() async {
    var status =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    final finalStatus = status[PermissionGroup.storage];
    return finalStatus == PermissionStatus.granted;
  }

  Future<bool> getCameraPermission() async {
    var status =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    final finalStatus = status[PermissionGroup.camera];
    return finalStatus == PermissionStatus.granted;
  }

  Future<bool> getLocationPermission() async {
    var status = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    final finalStatus = status[PermissionGroup.location];
    return finalStatus == PermissionStatus.granted;
  }

  void checkStatus(PermissionStatus permissionStatus) {
    switch (permissionStatus) {
      case PermissionStatus.granted:
        break;
      case PermissionStatus.disabled:
        break;
      case PermissionStatus.denied:
        break;
      case PermissionStatus.restricted:
        break;
    }
  }

  Future<File> openCamera() async {
    File file;
    var isCameraPermissionGranted = await getCameraPermission();
    if (isCameraPermissionGranted) {
      file = await ImagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 85);
      return file;
    } else {
      return file;
    }
  }

  Future<File> openGallery() async {
    File file;
    var isStoragePermissionGranted = await getStoragePermission();
    if (isStoragePermissionGranted) {
      file = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 85);
      return file;
    } else {
      return file;
    }
  }
}
