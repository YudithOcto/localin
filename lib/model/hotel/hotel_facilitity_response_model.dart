import 'package:equatable/equatable.dart';

class HotelFacilityResponseModel with EquatableMixin {
  @override
  List<Object> get props => [error, message, total, model];
  bool error;
  String message;
  int total;
  List<HotelFacilityDetailModel> model;

  HotelFacilityResponseModel(
      {this.error, this.message, this.total, this.model});

  factory HotelFacilityResponseModel.fromJson(Map<String, dynamic> body) {
    return HotelFacilityResponseModel(
      model: List<HotelFacilityDetailModel>.from(body['data']['data']
          .map((e) => HotelFacilityDetailModel.fromJson(e))),
      error: false,
      message: body['message'],
      total: body['data'] == null ? 0 : body['data']['paging']['total'],
    );
  }

  HotelFacilityResponseModel.withError(String message)
      : message = message,
        error = true,
        total = 0,
        model = List();
}

class HotelFacilityDetailModel with EquatableMixin {
  @override
  List<Object> get props => [facilityName, id];

  String facilityName;
  String id;

  HotelFacilityDetailModel({this.facilityName, this.id});

  factory HotelFacilityDetailModel.fromJson(Map<String, dynamic> body) {
    return HotelFacilityDetailModel(
      facilityName: body['fasilitas'],
      id: body['id'],
    );
  }
}
