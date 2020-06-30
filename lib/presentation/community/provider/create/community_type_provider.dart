import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_create_request_model.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';

class CommunityTypeProvider with ChangeNotifier {
  final _repository = Repository();

  Future<CommunityDetailBaseResponse> createCommunity(
      {CommunityCreateRequestModel model}) async {
    Map<String, dynamic> map = Map();
    map['nama'] = model.communityName;
    map['deskripsi'] = model.description;
    map['address'] = model.locations;
    map['type'] = _type;
    map['kategori'] = model.category.id;
    map['logo'] = MultipartFile.fromFileSync(model.imageFile.path,
        filename: model.imageFile.path);
    FormData _formApi = FormData.fromMap(map);
    final response = await _repository.createCommunity(_formApi);
    return response;
  }

  Future<BookingPaymentResponse> payTransaction(String transactionId) async {
    return await _repository.payTransaction(transactionId);
  }

  String price = '0';
  Future<String> getCommunityPrice() async {
    final result = await _repository.getCommunityPrice();
    price = result;
    return result;
  }

  String _type = '';
  String get typeCommunity => _type;
  void setType(String type) {
    _type = type;
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
