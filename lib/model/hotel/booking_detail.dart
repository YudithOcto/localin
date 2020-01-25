class BookingDetail {
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
  String updatedAt;

  BookingDetail(
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
      this.status,
      this.updatedAt});

  factory BookingDetail.fromJson(Map<String, dynamic> body) {
    return BookingDetail(
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
        updatedAt: body['updated_at']);
  }
}
