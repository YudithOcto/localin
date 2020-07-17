import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/model/explore/explore_event_submission_details.dart';
import 'package:localin/model/explore/explore_response_model.dart';
import 'package:localin/model/explore/single_person_form_model.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/explore/submit_form/widgets/order_successful_page.dart';
import 'package:localin/presentation/transaction/provider/transaction_detail_provider.dart';
import 'package:localin/presentation/webview/webview_page.dart';
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
    List<SinglePersonFormModel> eventRequestForm = routes[orderVisitorsName];
    ExploreOrderDetail _orderDetail = routes[orderApiReturned];
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            MainBottomNavigation.routeName, (route) => false);
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
                pageTitle: 'Confirmation Details',
                leadingIcon: InkWell(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      MainBottomNavigation.routeName, (route) => false),
                  child: Icon(
                    Icons.arrow_back,
                    color: ThemeColors.black100,
                  ),
                ),
              ),
              bottomNavigationBar: InkWell(
                onTap: () async {
                  CustomDialog.showLoadingDialog(context,
                      message: 'Please wait ..');
                  final getUrl = await Provider.of<TransactionDetailProvider>(
                          context,
                          listen: false)
                      .payTransaction(_orderDetail?.transactionId);
                  CustomDialog.closeDialog(context);
                  final payment = await Navigator.of(context)
                      .pushNamed(WebViewPage.routeName, arguments: {
                    WebViewPage.urlName: getUrl?.urlRedirect,
                    WebViewPage.title: 'Explore Transaction',
                  });
                  if (payment != null && payment == SUCCESS_VERIFICATION) {
                    Navigator.of(context)
                        .pushNamed(OrderSuccessfulPage.routeName);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MainBottomNavigation.routeName, (route) => false);
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
                child: Column(
                  children: <Widget>[
                    singleConfirmationRow('Ticket', detail?.eventName ?? ''),
                    singleConfirmationRow('Date', detail?.eventDate),
                    Divider(
                      thickness: 1.5,
                      color: ThemeColors.black20,
                    ),
                    Column(
                        children:
                            List.generate(eventRequestForm.length, (index) {
                      return singleConfirmationRow(
                          'Ticket ${index + 1} (${eventRequestForm[index]?.ticketType})',
                          eventRequestForm[index]?.name);
                    })),
                    Divider(
                      thickness: 1.5,
                      color: ThemeColors.black20,
                    ),
                    singleConfirmationRow('Ticket (${detail?.totalTicket})',
                        '${getFormattedCurrency(_orderDetail?.invoicePaymentTotal)}'),
                    singleConfirmationRow('Admin Fee',
                        '${getFormattedCurrency(_orderDetail?.adminFee)}'),
                    singleConfirmationRow('Total Amount',
                        '${getFormattedCurrency(_orderDetail.invoicePaymentTotal + _orderDetail?.adminFee)}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget singleConfirmationRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 4,
            child: Text(
              title,
              style: ThemeText.sfMediumFootnote
                  .copyWith(color: ThemeColors.black80),
            ),
          ),
          SizedBox(width: 10.0),
          Flexible(
              flex: 6, child: Text(value, style: ThemeText.sfMediumFootnote)),
        ],
      ),
    );
  }
}
