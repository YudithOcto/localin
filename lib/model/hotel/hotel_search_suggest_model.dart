import 'package:equatable/equatable.dart';
import 'package:localin/model/hotel/hotel_suggest_base.dart';

class HotelSearchSuggestModel with EquatableMixin {
  @override
  List<Object> get props => [];

  List<SuggestLocationModel> location;
  List<SuggestHotelModel> hotel;
  String message;

  HotelSearchSuggestModel({this.location, this.hotel, this.message});

  factory HotelSearchSuggestModel.fromJson(Map<String, dynamic> body) {
    return HotelSearchSuggestModel(
      location: List<SuggestLocationModel>.from(
        body['location'].map((e) => SuggestLocationModel.fromJson(e)),
      ),
      hotel: List<SuggestHotelModel>.from(
        body['hotel'].map((e) => SuggestHotelModel.fromJson(e)),
      ),
      message: '',
    );
  }

  HotelSearchSuggestModel.withError(String message) : message = message;
}

class SuggestHotelModel extends HotelSuggestBase with EquatableMixin {
  @override
  List<Object> get props => [id, suggest, address];

  String suggest;
  int id;
  String address;

  SuggestHotelModel({this.id, this.suggest, this.address});

  factory SuggestHotelModel.fromJson(Map<String, dynamic> body) {
    return SuggestHotelModel(
      suggest: body['suggest'] == null ? '' : body['suggest'],
      id: body['jumlah'] == null ? 0 : body['jumlah'],
      address: body['address'] == null ? '' : body['address'],
    );
  }
}

class SuggestLocationModel extends HotelSuggestBase with EquatableMixin {
  @override
  List<Object> get props => [total, suggest];

  String suggest;
  int total;

  SuggestLocationModel({this.total, this.suggest});

  factory SuggestLocationModel.fromJson(Map<String, dynamic> body) {
    return SuggestLocationModel(
      suggest: body['suggest'] == null ? '' : body['suggest'],
      total: body['jumlah'] == null ? 0 : body['jumlah'],
    );
  }
}
