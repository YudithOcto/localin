import 'package:localin/model/hotel/room_availability.dart';

class RoomBaseResponse {
  int discount;
  String error;
  List<RoomAvailability> roomAvailability;

  RoomBaseResponse({this.discount, this.roomAvailability, this.error});

  factory RoomBaseResponse.fromJson(Map<String, dynamic> body) {
    List rooms = body['rooms'];
    return RoomBaseResponse(
      discount: body['diskon'] ?? 0,
      error: null,
      roomAvailability: rooms == null
          ? null
          : rooms.map((value) => RoomAvailability.fromJson(value)).toList(),
    );
  }

  RoomBaseResponse.withError(String value)
      : error = value,
        roomAvailability = [],
        discount = 0;
}
