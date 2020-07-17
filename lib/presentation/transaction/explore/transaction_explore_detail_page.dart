import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/transaction/transaction_explore_detail_response.dart';
import 'package:localin/presentation/shared_widgets/top_bar_transaction_status_widget.dart';
import 'package:localin/presentation/transaction/explore/widgets/explore_booking_detail_widget.dart';
import 'package:localin/presentation/transaction/explore/widgets/explore_location_detail_widget.dart';
import 'package:localin/presentation/transaction/explore/widgets/explore_price_detail_widget.dart';
import 'package:localin/presentation/transaction/explore/widgets/explore_visitor_detail_widget.dart';
import 'package:localin/presentation/transaction/provider/transaction_detail_provider.dart';
import 'package:localin/presentation/transaction/shared_widgets/bottom_button_payment_widget.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class TransactionExploreDetailPage extends StatelessWidget {
  static const routeName = 'TransactionExploreDetailPage';
  static const transactionId = 'TransactionId';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionDetailProvider>(
      create: (_) => TransactionDetailProvider(),
      child: TransactionExploreContentWidget(),
    );
  }
}

class TransactionExploreContentWidget extends StatefulWidget {
  @override
  _TransactionExploreContentWidgetState createState() =>
      _TransactionExploreContentWidgetState();
}

class _TransactionExploreContentWidgetState
    extends State<TransactionExploreContentWidget> {
  bool _isInit = true;
  String _transactionId;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _transactionId = routeArgs[TransactionExploreDetailPage.transactionId];
      Provider.of<TransactionDetailProvider>(context, listen: false)
          .getCommunityTransactionDetail(
              _transactionId, kTransactionTypeExplore);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _cancelPayment() async {
    final result = await startDialog();
    if (result != null && result == 'Pay') {
      CustomDialog.showLoadingDialog(context, message: 'Please wait');
      final result =
          await Provider.of<TransactionDetailProvider>(context, listen: false)
              .cancelTransaction(_transactionId);
      CustomDialog.closeDialog(context);
      CustomToast.showCustomBookmarkToast(context, result);
      Navigator.of(context).pop();
    }
  }

  _payNowDialog() async {
    final result = await startDialog();
    if (result != null && result == 'Pay') {
      CustomDialog.showLoadingDialog(context, message: 'Please wait');
      final result =
          await Provider.of<TransactionDetailProvider>(context, listen: false)
              .payTransaction(_transactionId);
      CustomDialog.closeDialog(context);
      if (result.error) {
        CustomToast.showCustomBookmarkToast(context, result?.message);
        return;
      }
      final response = await Navigator.of(context)
          .pushNamed(WebViewPage.routeName, arguments: {
        WebViewPage.urlName: result?.urlRedirect,
        WebViewPage.title: 'Explore Transaction',
      });
      if (response != null && response == SUCCESS_VERIFICATION) {
        Provider.of<TransactionDetailProvider>(context, listen: false)
            .getCommunityTransactionDetail(
                _transactionId, kTransactionTypeExplore);
      }
    }
  }

  startDialog() {
    return CustomDialog.showCustomDialogStaticVerticalButton(context,
        title: 'Pay Now',
        message: 'Purchase this order now?',
        okText: 'Pay',
        cancelText: 'Cancel',
        onCancel: () => Navigator.of(context).pop(),
        okCallback: () {
          Navigator.of(context).pop('Pay');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: CustomAppBar(
        appBar: AppBar(),
        pageTitle: 'Purchase Details',
        leadingIcon: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
      ),
      bottomNavigationBar: Consumer<TransactionDetailProvider>(
        builder: (_, provider, __) {
          Data detail = provider.transactionDetail;
          return BottomButtonPaymentWidget(
            isVisible: detail?.status == kTransactionWaitingPayment ?? false,
            onCancelPressed: _cancelPayment,
            onPaymentPressed: _payNowDialog,
          );
        },
      ),
      body: StreamBuilder<transactionCommunityState>(
          stream: Provider.of<TransactionDetailProvider>(context, listen: false)
              .transStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: FractionalOffset.center,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: CircularProgressIndicator(),
              );
            } else {
              Data detail = Provider.of<TransactionDetailProvider>(context)
                  .transactionDetail;
              if (detail != null) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TopBarTransactionStatusWidget(
                        backgroundColor: ThemeColors.orange,
                        status: detail?.status,
                        expiredAt: detail?.expiredAt,
                      ),
                      ExploreBookingDetailWidget(
                        exploreDetail: detail,
                      ),
                      ExploreVisitorDetailWidget(
                        exploreDetail: detail,
                      ),
                      ExploreLocationDetailWidget(
                        exploreDetail: detail,
                      ),
                      ExplorePriceDetailWidget(
                        exploreDetail: detail,
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }
          }),
    );
  }
}
