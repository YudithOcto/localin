import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_cancel_response.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';
import 'package:localin/presentation/transaction/provider/transaction_detail_provider.dart';

class TransactionHotelDetailProvider with ChangeNotifier {
  final _repository = Repository();

  BookingDetailModel _bookingDetail = BookingDetailModel();

  BookingDetailModel get bookingDetailModel => _bookingDetail;

  final _streamController =
      StreamController<transactionDetailState>.broadcast();

  Stream<transactionDetailState> get stream => _streamController.stream;

  Future<Null> getBookingHistoryDetail(String bookingDetailId) async {
    _streamController.add(transactionDetailState.loading);
    final result = await _repository.getBookingDetail(bookingDetailId);
    if (result != null && result.error == null) {
      _bookingDetail = result.data;
      _streamController.add(transactionDetailState.success);
    } else {
      _streamController.add(transactionDetailState.empty);
    }
    notifyListeners();
  }

  Future<BookingCancelResponse> cancelBooking() async {
    final result = await _repository.cancelBooking(_bookingDetail.bookingId);
    return result;
  }

  Future<BookingPaymentResponse> payTransaction() async {
    return await _repository.bookingPayment(_bookingDetail.bookingId);
  }

  bool _trackNeedRefresh = false;

  bool get trackNeedRefresh => _trackNeedRefresh;

  set changeTrackRefresh(bool value) {
    _trackNeedRefresh = value;
    notifyListeners();
  }

  set changeTransactionType(String type) {
    _bookingDetail.status = type;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
