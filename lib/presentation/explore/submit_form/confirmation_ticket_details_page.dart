import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/explore/explore_event_submission_details.dart';
import 'package:localin/model/explore/single_person_form_model.dart';
import 'package:localin/model/explore/submit_form_request_model.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/explore/submit_form/providers/submit_confirmation_order_provider.dart';
import 'package:localin/presentation/explore/submit_form/widgets/order_successful_page.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class ConfirmationTicketDetailsPage extends StatelessWidget {
  static const routeName = 'ConfirmationTicketDetailsPage';
  static const basicOrderInfo = 'BasicOrderInfo';
  static const eventPersonFormDetail = 'eventPersonFormDetail';
  static const eventApiRequestForm = 'eventApiRequestForm';
  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    ExploreEventSubmissionDetails detail = routes[basicOrderInfo];
    SubmitFormRequestModel apiRequest = routes[eventPersonFormDetail];
    List<SinglePersonFormModel> eventRequestForm = routes[eventApiRequestForm];
    return ChangeNotifierProvider<SubmitConfirmationOrderProvider>(
        create: (_) => SubmitConfirmationOrderProvider(),
        child: LayoutBuilder(
          builder: (context, builder) {
            return Scaffold(
              backgroundColor: ThemeColors.black0,
              appBar: CustomAppBar(
                appBar: AppBar(),
                titleStyle: ThemeText.sfMediumHeadline,
                pageTitle: 'Confirmation Details',
                leadingIcon: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: ThemeColors.black100,
                  ),
                ),
              ),
              bottomNavigationBar: InkWell(
                onTap: () async {
                  CustomDialog.showLoadingDialog(context,
                      message: 'Please Wait ...');
                  final provider = Provider.of<SubmitConfirmationOrderProvider>(
                      context,
                      listen: false);
                  final result = await provider.orderTicket(apiRequest);
                  CustomDialog.closeDialog(context);
                  if (result.error) {
                    CustomToast.showCustomBookmarkToast(
                        context, result?.message);
                  } else {
                    final payment = await Navigator.of(context)
                        .pushNamed(WebViewPage.routeName, arguments: {
                      WebViewPage.urlName: result?.data?.urlRedirect,
                      WebViewPage.title: 'Explore Transaction',
                    });
                    if (payment != null && payment == SUCCESS_VERIFICATION) {
                      Navigator.of(context)
                          .pushNamed(OrderSuccessfulPage.routeName);
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          MainBottomNavigation.routeName, (route) => false);
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
                    'Confirm Booking',
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
                        '${getFormattedCurrency(detail?.totalPrice)}'),
                    singleConfirmationRow('Admin Fee', 'IDR 0'),
                    singleConfirmationRow('Total Amount',
                        '${getFormattedCurrency(detail?.totalPrice)}'),
                  ],
                ),
              ),
            );
          },
        ));
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
