import 'package:flutter/material.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/transaction/provider/transaction_detail_provider.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class BottomButtonPaymentWidget extends StatelessWidget {
  final bool isVisible;
  final String transactionId;
  final String type;
  BottomButtonPaymentWidget(
      {@required this.transactionId, this.isVisible, @required this.type});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => _cancelPayment(context),
              child: Container(
                height: 48.0,
                alignment: FractionalOffset.center,
                decoration: BoxDecoration(
                  color: ThemeColors.black60,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(4.0)),
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
            child: InkWell(
              onTap: () => _payNowDialog(context),
              child: Container(
                height: 48.0,
                alignment: FractionalOffset.center,
                decoration: BoxDecoration(
                  color: ThemeColors.primaryBlue,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(4.0)),
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
        ],
      ),
    );
  }

  _cancelPayment(BuildContext context) async {
    final result = await startDialog(context, 'Cancel Order',
        'You want to cancel order?', 'Cancel Order', 'Close');
    if (result != null && result == 'Pay') {
      final provider =
          Provider.of<TransactionDetailProvider>(context, listen: false);
      CustomDialog.showLoadingDialog(context, message: 'Please wait');
      final result = await provider.cancelTransaction(transactionId);
      CustomDialog.closeDialog(context);
      CustomToast.showCustomBookmarkToast(context, result);
      if (!result.contains('cannot')) {
        provider.navigateRefresh = true;
        provider.updateTransactionDetail(type, kTransactionCancelled);
      }
    }
  }

  _payNowDialog(BuildContext context) async {
    final result = await startDialog(
        context, 'Pay Now', 'Purchase this order now?', 'Pay', 'Cancel');
    if (result != null && result == 'Pay') {
      CustomDialog.showLoadingDialog(context, message: 'Please wait');
      final result =
          await Provider.of<TransactionDetailProvider>(context, listen: false)
              .payTransaction(transactionId);
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
            Provider.of<TransactionDetailProvider>(context, listen: false);
        provider.navigateRefresh = true;
        provider.updateTransactionDetail(type, 'Finished');
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
