import 'package:equatable/equatable.dart';

class RevampHotelListRequest with EquatableMixin {
  @override
  List<Object> get props => [search, checkIn, checkout, totalRooms];

  String search;
  DateTime checkIn;
  DateTime checkout;
  int totalRooms;

  RevampHotelListRequest(
      {this.search, this.checkIn, this.checkout, this.totalRooms});
}
