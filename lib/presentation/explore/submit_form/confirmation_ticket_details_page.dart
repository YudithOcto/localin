import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/model/explore/explore_event_submission_details.dart';
import 'package:localin/model/explore/explore_response_model.dart';
import 'package:localin/model/transaction/transaction_discount_response_model.dart';
import 'package:localin/presentation/explore/submit_form/widgets/confirmation_booking_detail.dart';
import 'package:localin/presentation/explore/submit_form/widgets/confirmation_visitor_detail.dart';
import 'package:localin/presentation/explore/submit_form/widgets/order_successful_page.dart';
import 'package:localin/presentation/explore/submit_form/widgets/single_confirmation_row.dart';
import 'package:localin/presentation/explore/submit_form/widgets/title_grey_section.dart';
import 'package:localin/presentation/transaction/explore/transaction_explore_detail_page.dart';
import 'package:localin/presentation/transaction/provider/transaction_detail_provider.dart';
import 'package:localin/presentation/webview/transaction_webview.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class ConfirmationTicketDetailsPage extends StatelessWidget {
  static const routeName = 'ConfirmationTicketDetailsPage';
  static const basicOrderInfo = 'BasicOrderInfo';
  static const orderVisitorsName = 'eventApiRequestForm';
  static const orderApiReturned = 'OrderApiReturned';

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    ExploreEventSubmissionDetails detail = routes[basicOrderInfo];
    ExploreOrderDetail _orderDetail = routes[orderApiReturned];
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            TransactionExploreDetailPage.routeName, (route) => false,
            arguments: {
              TransactionExploreDetailPage.transactionId:
                  _orderDetail.transactionId,
              TransactionExploreDetailPage.fromOutSideTransaction: true,
            });
        return false;
      },
      child: ChangeNotifierProvider<TransactionDetailProvider>(
        create: (_) => TransactionDetailProvider(),
        child: LayoutBuilder(
          builder: (context, builder) {
            return Scaffold(
              backgroundColor: ThemeColors.black0,
              appBar: CustomAppBar(
                appBar: AppBar(),
                titleStyle: ThemeText.sfMediumHeadline,
                pageTitle: 'Booking Confirmation',
                leadingIcon: InkWell(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      TransactionExploreDetailPage.routeName, (route) => false,
                      arguments: {
                        TransactionExploreDetailPage.transactionId:
                            _orderDetail.transactionId,
                        TransactionExploreDetailPage.fromOutSideTransaction:
                            true,
                      }),
                  child: Icon(
                    Icons.arrow_back,
                    color: ThemeColors.black100,
                  ),
                ),
              ),
              bottomNavigationBar: InkWell(
                onTap: () async {
                  if (detail.totalPrice <= 0) {
                    Navigator.of(context)
                        .pushNamed(OrderSuccessfulPage.routeName, arguments: {
                      OrderSuccessfulPage.transactionId:
                          _orderDetail.transactionId
                    });
                  } else {
                    CustomDialog.showLoadingDialog(context,
                        message: 'Please wait ..');
                    final getUrl = await Provider.of<TransactionDetailProvider>(
                            context,
                            listen: false)
                        .payTransaction(_orderDetail?.transactionId);
                    CustomDialog.closeDialog(context);
                    final payment = await Navigator.of(context)
                        .pushNamed(TransactionWebView.routeName, arguments: {
                      TransactionWebView.urlName: getUrl?.urlRedirect,
                      TransactionWebView.title: 'Explore Transaction',
                    });
                    if (payment != null && payment == SUCCESS_VERIFICATION) {
                      Navigator.of(context)
                          .pushNamed(OrderSuccessfulPage.routeName, arguments: {
                        OrderSuccessfulPage.transactionId:
                            _orderDetail.transactionId
                      });
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          TransactionExploreDetailPage.routeName,
                          (route) => false,
                          arguments: {
                            TransactionExploreDetailPage.transactionId:
                                _orderDetail.transactionId,
                            TransactionExploreDetailPage.fromOutSideTransaction:
                                true,
                          });
                    }
                  }
                },
                child: Container(
                  height: 48.0,
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryBlue,
                  ),
                  child: Text(
                    'Pay Now',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Consumer<TransactionDetailProvider>(
                  builder: (_, provider, __) => Column(
                    children: <Widget>[
                      ConfirmationBookingDetail(detail: detail),
                      ConfirmationVisitorDetail(
                          eventRequestForm: routes[orderVisitorsName]),
                      TitleGreySection(title: 'price detail'),
                      SingleConfirmationRow('Ticket (${detail?.totalTicket})',
                          '${_orderDetail?.invoicePaymentTotal?.transformTicketPrice}'),
                      SingleConfirmationRow('Admin Fee',
                          '${_orderDetail?.adminFee?.transformTicketPrice}'),
                      Visibility(
                        visible: provider.priceData != null &&
                            provider.priceData.couponDiscount != null &&
                            provider.priceData.couponDiscount > 0,
                        child: SingleConfirmationRow(
                          'Coupon',
                          '- ${getFormattedCurrency(provider.priceData?.couponDiscount)}',
                        ),
                      ),
                      Visibility(
                        visible: provider.priceData != null &&
                            provider.priceData.pointDiscount != null &&
                            provider.priceData.pointDiscount > 0,
                        child: SingleConfirmationRow(
                          'Local Point',
                          '- ${getFormattedCurrency(provider.priceData?.pointDiscount)}',
                        ),
                      ),
                      SingleConfirmationRow('Total Amount',
                          '${getTotalAmount((_orderDetail.invoicePaymentTotal + _orderDetail?.adminFee), provider.priceData)}'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String getTotalAmount(int basicTotal, PriceData price) {
    if (price != null &&
        (price.couponDiscount > 0 || price.pointDiscount > 0)) {
      return getFormattedCurrency(price.userPrice);
    } else {
      return getFormattedCurrency(basicTotal);
    }
  }
}

extension on int {
  String get transformTicketPrice {
    if (this == null || this == 0) return 'Free';
    return getFormattedCurrency(this);
  }
}
