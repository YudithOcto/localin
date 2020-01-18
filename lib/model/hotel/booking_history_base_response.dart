class BookingHistoryBaseResponse {
  String error;
  String message;
  List<BookingHistoryDetail> detail;

  BookingHistoryBaseResponse({this.error, this.message, this.detail});

  BookingHistoryBaseResponse.withError()
      : error = 'an error occured',
        this.message = null,
        detail = null;

  factory BookingHistoryBaseResponse.fromJson(Map<String, dynamic> body) {
    List detail = body['data']['data'];
    return BookingHistoryBaseResponse(
        error: null,
        message: body['message'],
        detail: detail == null
            ? null
            : detail
                .map((value) => BookingHistoryDetail.fromJson(value))
                .toList());
  }
}

class BookingHistoryDetail {
  int hotelId;
  String name;
  String street;
  String state;
  String country;
  String bookingId;
  String invoiceCode;
  String currencyCode;
  int userPrice;
  String checkIn;
  String checkOut;
  String status;

  BookingHistoryDetail(
      {this.hotelId,
      this.name,
      this.street,
      this.state,
      this.country,
      this.bookingId,
      this.invoiceCode,
      this.currencyCode,
      this.userPrice,
      this.checkIn,
      this.checkOut,
      this.status});

  factory BookingHistoryDetail.fromJson(Map<String, dynamic> body) {
    return BookingHistoryDetail(
      hotelId: body['hotel_id'],
      name: body['name'],
      street: body['street'],
      state: body['state'],
      country: body['country'],
      bookingId: body['booking_id'],
      invoiceCode: body['invoice_kode'],
      currencyCode: body['currencyCode'],
      userPrice: body['hargaUser'],
      checkIn: body['checkin'],
      checkOut: body['checkout'],
      status: body['status'],
    );
  }
}
