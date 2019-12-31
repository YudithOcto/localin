import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/utils/helper_permission.dart';

class CommunityEventProvider extends BaseModelProvider {
  TextEditingController eventTitleController = TextEditingController();
  TextEditingController eventCategoryController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventAddressController = TextEditingController();
  TextEditingController eventDistrictController = TextEditingController();
  TextEditingController eventCityController = TextEditingController();
  TextEditingController eventPaymentController = TextEditingController();
  Repository _repository = Repository();
  HelperPermission _permissionHelper = HelperPermission();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  File attachmentImage;
  DateTime startEventDate = DateTime.now();
  DateTime endEventDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay startEventTime = TimeOfDay.now();
  TimeOfDay endEventTime = TimeOfDay.now();
  bool paymentNeeded = false;

  @override
  void dispose() {
    eventTitleController.dispose();
    eventCategoryController.dispose();
    eventDescriptionController.dispose();
    eventAddressController.dispose();
    eventDistrictController.dispose();
    eventCityController.dispose();
    eventPaymentController.dispose();
    super.dispose();
  }

  Future<String> getImageFromCamera() async {
    var result = await _permissionHelper.openCamera();
    if (result != null) {
      attachmentImage = result;
      return '';
    }
    return 'You need to grant permission for camera';
  }

  Future<String> getImageFromStorage() async {
    var result = await _permissionHelper.openGallery();
    if (result != null) {
      attachmentImage = result;
      return '';
    }
    return 'You need to grant permission for storage';
  }

  void setPaymentStatus(bool paymentStatus) {
    this.paymentNeeded = paymentStatus;
    notifyListeners();
  }
}
