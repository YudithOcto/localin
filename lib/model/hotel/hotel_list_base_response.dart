class HotelListBaseResponse {
  String error;
  String message;
  int total;
  List<HotelDetailEntity> hotelDetailEntity;
  HotelDetailEntity singleHotelEntity;

  HotelListBaseResponse(
      {this.error, this.message, this.total, this.hotelDetailEntity});

  HotelListBaseResponse.withError(String value)
      : error = value,
        message = null,
        hotelDetailEntity = null;

  factory HotelListBaseResponse.fromJson(Map<String, dynamic> body) {
    return HotelListBaseResponse(
        message: body['message'],
        error: null,
        total: body['paging']['total'] ?? null,
        hotelDetailEntity: (body['data'] as List)
            .map((v) => HotelDetailEntity.fromJson(v))
            .toList());
  }

  HotelListBaseResponse.withJson(Map<String, dynamic> body)
      : message = body['message'],
        error = null,
        singleHotelEntity = HotelDetailEntity.fromJson(body['data']);
}

class HotelDetailEntity {
  int hotelId;
  String oyoId;
  String hotelName;
  String countryCode;
  String description;
  String street;
  String city;
  String state;
  String country;
  String zipCode;
  String latitude;
  String longitude;
  String shortAddress;
  String landingUrl;
  String category;
  String distance;
  int discount;
  List<RoomAvailability> roomAvailability;
  List<String> facilities;
  List<String> policies;
  List<String> restrictions;
  List<String> images;

  HotelDetailEntity({
    this.hotelId,
    this.oyoId,
    this.hotelName,
    this.countryCode,
    this.description,
    this.street,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.shortAddress,
    this.landingUrl,
    this.category,
    this.distance,
    this.discount,
    this.roomAvailability,
    this.facilities,
    this.policies,
    this.restrictions,
    this.images,
  });

  factory HotelDetailEntity.fromJson(Map<String, dynamic> body) {
    List facilities = body['fasilitas'];
    List images = body['image'];
    List policies = body['policies'];
    List restriction = body['restrictions'];
    List availability = body['availability'];
    return HotelDetailEntity(
        hotelId: body['hotel_id'],
        oyoId: body['oyoId'],
        hotelName: body['name'],
        countryCode: body['negaraCode'],
        description: body['description'],
        street: body['street'],
        city: body['city'],
        state: body['state'],
        country: body['country'],
        zipCode: body['zipcode'],
        latitude: body['latitude'],
        longitude: body['longitude'],
        shortAddress: body['shortAddress'],
        landingUrl: body['landingUrl'],
        category: body['category'],
        distance: body['distance'],
        discount: body['diskon'],
        facilities: facilities == null
            ? null
            : facilities.map((value) => value as String).toList(),
        images: images == null
            ? null
            : images.map((value) => value as String).toList(),
        policies: policies == null
            ? null
            : policies.map((value) => value as String).toList(),
        restrictions: restriction == null
            ? null
            : restriction.map((value) => value as String).toList(),
        roomAvailability: availability == null
            ? null
            : availability
                .map((value) => RoomAvailability.fromJson(value))
                .toList());
  }
}

class RoomAvailability {
  int categoryId;
  String categoryName;
  int sellingAmount;
  PricePerNight pricePerNight;

  RoomAvailability(
      {this.categoryId,
      this.categoryName,
      this.sellingAmount,
      this.pricePerNight});

  factory RoomAvailability.fromJson(Map<String, dynamic> body) {
    return RoomAvailability(
      categoryId: body['categoryId'],
      categoryName: body['categoryName'],
      sellingAmount: body['sellingAmount'],
      pricePerNight: PricePerNight.fromJson(body['occupancyWisePerNightPrice']),
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
