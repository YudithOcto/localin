class BookingDetailResponse {
  String error;
  String message;
  BookingDetailModel data;

  BookingDetailResponse({this.error, this.message, this.data});

  factory BookingDetailResponse.fromJson(Map<String, dynamic> body) {
    return BookingDetailResponse(
      error: null,
      message: body['message'],
      data: BookingDetailModel.fromJson(body['data']),
    );
  }

  BookingDetailResponse.withError(String value)
      : error = value,
        data = null,
        message = null;
}

class BookingDetailModel {
  int hotelId;
  String name;
  String street;
  String state;
  String country;
  String bookingId;
  String invoiceCode;
  int responseId;
  String currencyCode;
  int userPrice;
  int checkIn;
  int checkOut;
  String status;
  String updatedAt;
  String createdAt;
  String expiredAt;
  String hotelImage;
  String roomName;
  int guestCount;
  HotelDetailModel hotelDetail;
  String requestCheckInDate;
  String requestCheckOutDate;
  int adminFee;
  int basicFee;
  int taxFee;
  int basicServiceFee;
  int couponDiscount;
  int pointDiscount;
  int singleRoomFee;
  int totalNight;

  BookingDetailModel({
    this.hotelId,
    this.name,
    this.street,
    this.state,
    this.country,
    this.bookingId,
    this.invoiceCode,
    this.responseId,
    this.currencyCode,
    this.userPrice,
    this.checkIn,
    this.checkOut,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.hotelImage,
    this.hotelDetail,
    this.expiredAt,
    this.roomName,
    this.guestCount,
    this.requestCheckInDate,
    this.requestCheckOutDate,
    this.adminFee,
    this.basicFee,
    this.pointDiscount,
    this.couponDiscount,
    this.basicServiceFee,
    this.taxFee,
    this.singleRoomFee,
    this.totalNight,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> body) {
    return BookingDetailModel(
      hotelId: body['hotel_id'],
      name: body['name'],
      street: body['street'],
      state: body['state'],
      country: body['country'],
      bookingId: body['booking_id'],
      invoiceCode: body['invoice_kode'],
      responseId: body['response_id'],
      currencyCode: body['currencyCode'],
      userPrice: body['hargaUser'],
      checkOut: body['checkout'],
      checkIn: body['checkin'],
      status: body['status'],
      createdAt: body['created_at'],
      updatedAt: body['updated_at'],
      hotelImage: body['hotel_image'],
      guestCount: body['adult_count'],
      roomName: body['room_name'],
      hotelDetail: body['hotel_detail'] == null
          ? null
          : HotelDetailModel.fromJson(body['hotel_detail']),
      expiredAt: body['expired_at'],
      requestCheckInDate: body['request_checkin'],
      requestCheckOutDate: body['request_checkout'],
      adminFee: body['admin_fee'] ?? 0,
      basicFee: body['dasar_harga'] ?? 0,
      basicServiceFee: body['dasar_service'] ?? 0,
      taxFee: body['dasar_ppn'] ?? 0,
      couponDiscount: body['diskon_kupon'] ?? 0,
      pointDiscount: body['diskon_poin'] ?? 0,
      singleRoomFee: body['single_price'] ?? 0,
      totalNight: body['night'] ?? 0,
    );
  }
}

class HotelDetailModel {
  int hotelId;
  String oyoId;
  String name;
  String latitude;
  String longitude;
  String category;
  String street;
  String state;
  String shortAddress;

  HotelDetailModel({
    this.hotelId,
    this.oyoId,
    this.name,
    this.latitude,
    this.longitude,
    this.category,
    this.street,
    this.state,
    this.shortAddress,
  });

  factory HotelDetailModel.fromJson(Map<String, dynamic> body) {
    return HotelDetailModel(
      hotelId: body['hotel_id'],
      oyoId: body['oyoId'],
      name: body['name'],
      latitude: body['latitude'],
      longitude: body['longitude'],
      category: body['category'],
      street: body['street'],
      state: body['state'],
      shortAddress: body['shortAddress'],
    );
  }
}
