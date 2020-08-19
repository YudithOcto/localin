class RoomAvailability {
  int categoryId;
  String categoryName;
  int sellingAmount;
  PricePerNight pricePerNight;
  int adminFee;

  RoomAvailability({
    this.categoryId,
    this.categoryName,
    this.sellingAmount,
    this.pricePerNight,
    this.adminFee,
  });

  factory RoomAvailability.fromJson(Map<String, dynamic> body) {
    return RoomAvailability(
      categoryId: body['categoryId'],
      categoryName: body['categoryName'],
      sellingAmount: body['sellingAmount'],
      pricePerNight: PricePerNight.fromJson(body['occupancyWisePerNightPrice']),
      adminFee: body['admin_fee'],
    );
  }
}

class PricePerNight {
  int oneNight;
  int twoNight;
  int threeNight;

  PricePerNight({this.oneNight, this.twoNight, this.threeNight});

  factory PricePerNight.fromJson(Map<String, dynamic> body) {
    return PricePerNight(
      oneNight: body['1'],
      twoNight: body['2'],
      threeNight: body['3'],
    );
  }
}
