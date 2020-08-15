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
  int totalAdults;
  int totalChild;
  double minPrice;
  double maxPrice;
  String sort;
  List<String> facilities;

  RevampHotelListRequest({
    this.search,
    this.checkIn,
    this.checkout,
    this.totalRooms,
    this.minPrice = DEFAULT_PRICE_LOWEST,
    this.maxPrice = DEFAULT_PRICE_HIGHEST,
    this.facilities,
    this.sort,
    this.totalAdults,
    this.totalChild,
  });
}
