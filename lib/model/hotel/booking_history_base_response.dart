import 'package:localin/model/hotel/booking_detail.dart';

class BookingHistoryBaseResponse {
  String error;
  String message;
  List<BookingDetail> detail;

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
            : detail.map((value) => BookingDetail.fromJson(value)).toList());
  }
}
