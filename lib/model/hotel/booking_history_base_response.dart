import 'package:localin/model/hotel/booking_detail.dart';

class BookingHistoryBaseResponse {
  String error;
  String message;
  int total;
  List<BookingDetail> detail;

  BookingHistoryBaseResponse(
      {this.error, this.message, this.detail, this.total});

  BookingHistoryBaseResponse.withError()
      : error = 'an error occured',
        this.message = null,
        detail = null;

  factory BookingHistoryBaseResponse.fromJson(Map<String, dynamic> body) {
    List detail = body['data']['data'];
    final paging = body['data']['paging'];
    return BookingHistoryBaseResponse(
        error: null,
        message: body['message'],
        total: paging != null ? paging['total'] : null,
        detail: detail == null
            ? null
            : detail.map((value) => BookingDetail.fromJson(value)).toList());
  }
}
