class BookingCancelResponse {
  String message;
  bool error;

  BookingCancelResponse({this.error, this.message});

  factory BookingCancelResponse.fromJson(Map<String, dynamic> body) {
    return BookingCancelResponse(
      message: body['message'],
      error: body['error'],
    );
  }

  BookingCancelResponse.withError(String value)
      : error = true,
        message = value;
}
