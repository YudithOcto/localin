import 'package:flutter/material.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/presentation/revamp_hotel/hotel_booking_confirmation/hotel_booking_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_successfull/hotel_successful_page.dart';
import 'package:localin/presentation/transaction/hotel/transaction_hotel_detail_page.dart';
import 'package:localin/presentation/webview/transaction_webview.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class HotelBookingBottomWidgetPayment extends StatelessWidget {
  final HotelDetailEntity hotelDetail;
  final RoomAvailability roomDetail;
  final RevampHotelListRequest request;

  HotelBookingBottomWidgetPayment(
      {this.hotelDetail, this.roomDetail, this.request});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () async {
        final result =
            await CustomDialog.showCustomDialogStaticVerticalButton(context,
                title: 'Confirm Booking',
                message: 'Are you sure want to booking this room?',
                cancelText: 'Cancel',
                okText: 'Booking',
                onCancel: () => Navigator.of(context).pop(),
                okCallback: () {
                  Navigator.of(context).pop(kRefresh);
                });
        if (result != null) {
          CustomDialog.showLoadingDialog(context, message: 'Please wait ...');
          final result =
              await Provider.of<HotelBookingProvider>(context, listen: false)
                  .bookHotel(request, hotelDetail.hotelId, roomDetail);
          if (result.error != null && result.error.isNotEmpty) {
            CustomDialog.closeDialog(context);
            CustomToast.showCustomBookmarkToast(context, result.message);
          } else {
            final urlResponse =
                await Provider.of<HotelBookingProvider>(context, listen: false)
                    .getMiniDanaUrl(result.detail.bookingId);
            CustomDialog.closeDialog(context);
            final navWebViewResult = await Navigator.of(context)
                .pushNamed(TransactionWebView.routeName, arguments: {
              TransactionWebView.urlName: urlResponse?.urlRedirect,
              TransactionWebView.title: 'Hotel Transaction',
            });
            if (navWebViewResult != null &&
                navWebViewResult == SUCCESS_VERIFICATION) {
              Navigator.of(context).pushReplacementNamed(
                  HotelSuccessfulPage.routeName,
                  arguments: {
                    HotelSuccessfulPage.bookingId: result.detail.bookingId,
                  });
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  TransactionHotelDetailPage.routeName, (route) => false,
                  arguments: {
                    TransactionHotelDetailPage.bookingId:
                        result?.detail?.bookingId,
                    TransactionHotelDetailPage.fromSuccessPage: true,
                  });
            }
          }
        }
      },
      highlightColor: ThemeColors.black0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        color: ThemeColors.primaryBlue,
        height: 48.0,
        alignment: FractionalOffset.center,
        child: Text(
          'Pay Now',
          style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
        ),
      ),
    );
  }
}
