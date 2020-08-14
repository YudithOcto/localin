import 'package:equatable/equatable.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_filter_provider.dart';

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
      this.minPrice = DEFAULT_PRICE_LOWEST,
      this.maxPrice = DEFAULT_PRICE_HIGHEST,
      this.sort});
}
