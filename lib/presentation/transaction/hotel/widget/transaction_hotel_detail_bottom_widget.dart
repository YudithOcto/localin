import 'package:flutter/material.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/presentation/transaction/hotel/provider/transaction_hotel_detail_provider.dart';
import 'package:localin/presentation/transaction/provider/transaction_detail_provider.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class TransactionHotelDetailBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionHotelDetailProvider>(context);
    return StreamBuilder<transactionDetailState>(
        stream: provider.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return provider.bookingDetailModel.status.contains('Confirm Booking')
              ? Container(
                  padding: const EdgeInsets.all(20.0),
                  child: FilledButtonDefault(
                    buttonText: 'Cancel this Booking',
                    textTheme: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                    onPressed: () {
                      _cancelPayment(context, 'Request Refund',
                          'Are you sure want to cancel your booking? Refunds will be transferred automatically to your Dana account.');
                    },
                  ),
                )
              : Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (DateTime.now().isAfter(DateTime.parse(
                              provider.bookingDetailModel.expiredAt))) {
                            _cancelPayment(context, 'Cancel Payment',
                                'Are you sure want to cancel your booking?');
                          } else {
                            _cancelPayment(context, 'Request Refund',
                                'Are you sure want to cancel your booking? Refunds will be transferred automatically to your Dana account.');
                          }
                        },
                        child: Container(
                          height: 48.0,
                          alignment: FractionalOffset.center,
                          decoration: BoxDecoration(
                            color: ThemeColors.black60,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0)),
                          ),
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: ThemeText.rodinaTitle3
                                .copyWith(color: ThemeColors.black0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Visibility(
                        visible: provider?.bookingDetailModel?.status
                                ?.contains('Waiting') ??
                            false,
                        child: InkWell(
                          onTap: () => _payNowDialog(context),
                          child: Container(
                            height: 48.0,
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                              color: ThemeColors.primaryBlue,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4.0)),
                            ),
                            child: Text(
                              'Pay Now',
                              textAlign: TextAlign.center,
                              style: ThemeText.rodinaTitle3
                                  .copyWith(color: ThemeColors.black0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        });
  }

  _cancelPayment(BuildContext context, String title, String message) async {
    final result =
        await startDialog(context, '$title', '$message', 'Yes', 'Cancel');
    if (result != null && result == 'Pay') {
      final provider =
          Provider.of<TransactionHotelDetailProvider>(context, listen: false);
      CustomDialog.showLoadingDialog(context, message: 'Please wait');
      final result = await provider.cancelBooking();
      CustomDialog.closeDialog(context);
      CustomToast.showCustomBookmarkToast(context, result?.message);
      if (!result.error) {
        provider.changeTrackRefresh = true;
        provider.changeTransactionType = kTransactionCancelled;
      }
    }
  }

  _payNowDialog(BuildContext context) async {
    final result = await startDialog(
        context, 'Pay Now', 'Purchase this booking now?', 'Pay', 'Cancel');
    if (result != null && result == 'Pay') {
      CustomDialog.showLoadingDialog(context, message: 'Please wait');
      final result = await Provider.of<TransactionHotelDetailProvider>(context,
              listen: false)
          .payTransaction();
      CustomDialog.closeDialog(context);
      if (result.error) {
        CustomToast.showCustomBookmarkToast(context, result?.message);
        return;
      }
      final response = await Navigator.of(context)
          .pushNamed(WebViewPage.routeName, arguments: {
        WebViewPage.urlName: result?.urlRedirect,
        WebViewPage.title: 'Transaction',
      });
      if (response != null && response == SUCCESS_VERIFICATION) {
        final provider =
            Provider.of<TransactionHotelDetailProvider>(context, listen: false);
        provider.changeTrackRefresh = true;
        provider.changeTransactionType = 'Finished';
      }
    }
  }

  startDialog(BuildContext context, String title, String message, String okText,
      String cancelText) {
    return CustomDialog.showCustomDialogStaticVerticalButton(context,
        title: '$title',
        message: '$message',
        okText: '$okText',
        cancelText: '$cancelText',
        onCancel: () => Navigator.of(context).pop(),
        okCallback: () {
          Navigator.of(context).pop('Pay');
        });
  }
}
