import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  double latitude = 0.0, longitude = 0.0;
  HelperPermission _permissionHelper = HelperPermission();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  File attachmentImage;
  DateTime startEventDate = DateTime.now();
  DateTime endEventDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay startEventTime = TimeOfDay.now();
  TimeOfDay endEventTime = TimeOfDay.now();
  bool paymentNeeded = false;
  final format = DateFormat('yyyy-MM-dd');

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

  Future<void> createEvent() async {
    FormData formData = FormData.fromMap({
      'judul': eventTitleController.text ?? null,
      'deskripsi': eventDescriptionController.text ?? null,
      'start_date': format.format(startEventDate),
      'end_date': format.format(endEventDate),
      'start_time':
          '${startEventTime.hour}:${startEventTime.minute}:${startEventTime.minute % 60}',
      'end_time':
          '${endEventTime.hour}:${endEventTime.minute}:${endEventTime.minute % 60}',
      'alamat': eventAddressController.text ?? null,
      'kecamatan': eventDistrictController.text ?? null,
      'kota': eventCityController.text ?? null,
      'tipe': 'public',
      'biaya': eventPaymentController.text ?? null,
      'latitude': latitude,
      'longitude': longitude,
      'lampiran_tipe': 'image',
      'lampiran': attachmentImage != null
          ? MultipartFile.fromFileSync(attachmentImage.path,
              filename: attachmentImage.path)
          : null,
    });
  }

  void setStartDate(DateTime value) {
    this.startEventDate = value;
    notifyListeners();
  }

  void setEndDate(DateTime value) {
    this.endEventDate = value;
    notifyListeners();
  }

  void setStartTime(TimeOfDay value) {
    this.startEventTime = value;
    notifyListeners();
  }

  void setEndTime(TimeOfDay value) {
    this.endEventTime = value;
    notifyListeners();
  }
}
