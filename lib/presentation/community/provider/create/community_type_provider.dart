import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_create_request_model.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_price_model.dart';
import 'package:localin/model/community/community_type_request_model.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/number_helper.dart';

class CommunityTypeProvider with ChangeNotifier {
  final _repository = Repository();

  CommunityTypeRequestModel _communityTypeRequest;

  CommunityTypeRequestModel get communityTypeRequestModel =>
      _communityTypeRequest;

  void setCommunityType(String type) {
    if (type == 'paid') {
      _communityTypeRequest = CommunityTypeRequestModel(
          duration: '1 Year',
          communityType: 'Paid',
          until: ''
              '${DateHelper.formatDate(date: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day), format: 'dd MMM yyyy')}',
          price: '${getFormattedCurrency(priceModel?.totalFare)}');
    } else {
      _communityTypeRequest = CommunityTypeRequestModel(
          duration: 'Lifetime',
          communityType: 'Free',
          until: '-',
          price: 'IDR 0');
    }
    notifyListeners();
  }

  Future<CommunityDetailBaseResponse> createEditCommunity(
      {CommunityCreateRequestModel model}) async {
    Map<String, dynamic> map = Map();
    map['nama'] = model.communityName;
    map['deskripsi'] = model.description;
    map['address'] = model.locations.map((e) => e).toList();
    map['type'] = _type;
    map['kategori'] = model.category.id;
    map['logo'] = MultipartFile.fromFileSync(model.imageFile.path,
        filename: model.imageFile.path);
    CommunityDetailBaseResponse response;
    FormData _formApi = FormData.fromMap(map);
    if (model.isEditMode) {
      response = await _repository.editCommunity(_formApi, model.communityId);
    } else {
      response = await _repository.createCommunity(_formApi);
    }
    return response;
  }

  Future<BookingPaymentResponse> payTransaction(String transactionId) async {
    return await _repository.payTransaction(transactionId);
  }

  CommunityPriceDetail priceModel;

  Future<CommunityPriceDetail> getCommunityPrice() async {
    final result = await _repository.getCommunityPrice();
    if (!result.error) {
      priceModel = result.detail;
    }
    return priceModel;
  }

  String _type = '';

  String get typeCommunity => _type;

  void setType(String type) {
    _type = type;
    notifyListeners();
  }

  final _panelController = StreamController<bool>.broadcast();

  Stream<bool> get panelStream => _panelController.stream;

  Function(bool) get showPanel => _panelController.sink.add;

  @override
  void dispose() {
    _panelController.close();
    super.dispose();
  }
}
