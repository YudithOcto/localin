import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_create_request_model.dart';
import 'package:localin/model/community/community_detail_base_response.dart';

class CommunityTypeProvider with ChangeNotifier {
  final _repository = Repository();

  Future<CommunityDetailBaseResponse> createCommunity(
      {@required String type, CommunityCreateRequestModel model}) async {
    Map<String, dynamic> map = Map();
    map['nama'] = model.communityName;
    map['deskripsi'] = model.description;
    map['address'] = model.locations;
    map['type'] = type;
    map['kategori'] = model.category.id;
    map['logo'] = MultipartFile.fromFileSync(model.imageFile.path,
        filename: model.imageFile.path);
    FormData _formApi = FormData.fromMap(map);
    final response = await _repository.createCommunity(_formApi);
    return response;
  }

  Future<String> getCommunityPrice() async {
    return await _repository.getCommunityPrice();
  }
}
