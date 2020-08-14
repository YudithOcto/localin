import 'package:equatable/equatable.dart';

class RevampHotelListRequest with EquatableMixin {
  @override
  List<Object> get props =>
      [search, checkIn, checkout, totalRooms, minPrice, maxPrice, sort];

  String search;
  DateTime checkIn;
  DateTime checkout;
  int totalRooms;
  double minPrice;
  double maxPrice;
  String sort;

  RevampHotelListRequest(
      {this.search,
      this.checkIn,
      this.checkout,
      this.totalRooms,
      this.minPrice,
      this.maxPrice,
      this.sort});
}
