class BookingPaymentResponse {
  String message;
  bool error;
  String urlRedirect;

  BookingPaymentResponse({this.message, this.error, this.urlRedirect});

  factory BookingPaymentResponse.fromJson(Map<String, dynamic> body) {
    return BookingPaymentResponse(
      message: body['message'],
      error: body['error'],
      urlRedirect: body['data'] != null ? body['data']['url_redirect'] : null,
    );
  }

  BookingPaymentResponse.withError(String value)
      : error = true,
        message = value,
        urlRedirect = '';
}
