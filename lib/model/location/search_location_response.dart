import 'package:equatable/equatable.dart';

class SearchLocationResponse {
  bool error;
  String message;
  int total;
  List<LocationResponseDetail> detail;

  SearchLocationResponse({this.error, this.message, this.total, this.detail});

  factory SearchLocationResponse.fromJson(Map<String, dynamic> body) {
    return SearchLocationResponse(
        error: body['error'],
        message: body['message'],
        total: body['data']['pagination']['total'],
        detail: List<LocationResponseDetail>.from(body['data']['data']
            .map((e) => LocationResponseDetail.fromJson(e))));
  }

  SearchLocationResponse.withError(String value)
      : message = value,
        error = true;
}

class LocationResponseDetail with EquatableMixin {
  String id;
  String city;
  String provinceId;
  String province;
  String addressText;

  LocationResponseDetail(
      {this.id, this.city, this.provinceId, this.province, this.addressText});

  factory LocationResponseDetail.fromJson(Map<String, dynamic> body) {
    return LocationResponseDetail(
      id: body['id'],
      city: body['kota'],
      provinceId: body['provinsi_id'],
      province: body['provinsi'],
      addressText: body['text'],
    );
  }

  @override
  List<Object> get props => [id, city, provinceId, province, addressText];
}
