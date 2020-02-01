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
  HotelDetailModel hotelDetail;

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
      hotelDetail: HotelDetailModel.fromJson(body['hotel_detail']),
      expiredAt: body['expired_at'],
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

  HotelDetailModel(
      {this.hotelId,
      this.oyoId,
      this.name,
      this.latitude,
      this.longitude,
      this.category});

  factory HotelDetailModel.fromJson(Map<String, dynamic> body) {
    return HotelDetailModel(
      hotelId: body['hotel_id'] ?? null,
      oyoId: body['oyoId'] ?? null,
      name: body['name'] ?? null,
      latitude: body['latitude'] ?? null,
      longitude: body['longitude'] ?? null,
      category: body['category'] ?? null,
    );
  }
}
