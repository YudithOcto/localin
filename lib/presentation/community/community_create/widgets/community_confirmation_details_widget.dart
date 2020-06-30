import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/model/community/community_create_request_model.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/presentation/community/provider/create/community_type_provider.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

import '../community_type_page.dart';
import 'community_payment_successful_page.dart';

class CommunityConfirmationDetailsWidget extends StatelessWidget {
  final Function onBackPressed;
  CommunityConfirmationDetailsWidget({Key key, this.onBackPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    showConfirmBookingDialog() async {
      CustomDialog.showCenteredLoadingDialog(context, message: 'Loading ...');
      final provider =
          Provider.of<CommunityTypeProvider>(context, listen: false);
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      CommunityCreateRequestModel model =
          routeArgs[CommunityTypePage.requestModel];
      final response = await provider.createCommunity(model: model);
      if (response.error == null) {
        CustomDialog.closeDialog(context);
        if (response.detailCommunity.transactionId == null ||
            response.detailCommunity.transactionId.isEmpty) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              CommunityDetailPage.routeName, (route) => false,
              arguments: {
                CommunityDetailPage.communityData: response.detailCommunity,
                CommunityDetailPage.needBackToHome: true,
              });
        } else {
          CustomDialog.showLoadingDialog(context, message: 'Please wait');
          final result = await provider
              .payTransaction(response.detailCommunity.transactionId);
          CustomDialog.closeDialog(context);
          final payment = await Navigator.of(context)
              .pushNamed(WebViewPage.routeName, arguments: {
            WebViewPage.urlName: result?.urlRedirect,
            WebViewPage.title: 'Dana',
          });
          if (payment != null && payment == SUCCESS_VERIFICATION) {
            Navigator.of(context).pushNamed(
                CommunityPaymentSuccessfulPage.routeName,
                arguments: {
                  CommunityPaymentSuccessfulPage.communityData:
                      response.detailCommunity
                });
          }
        }
      } else {
        CustomDialog.closeDialog(context);
        CustomDialog.showCustomDialogVerticalMultipleButton(context,
            title: 'Failed',
            message: response?.error ?? 'failed',
            dialogButtons: List.generate(
                1,
                (index) => FilledButtonDefault(
                      buttonText: 'Close',
                      textTheme: ThemeText.rodinaTitle3
                          .copyWith(color: ThemeColors.black0),
                      onPressed: () => Navigator.of(context).pop(),
                    )));
      }
    }

    return Consumer<CommunityTypeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: CustomAppBar(
            pageTitle: 'Confirmation Details',
            appBar: AppBar(),
            leadingIcon: InkWell(
              onTap: onBackPressed,
              child: Icon(
                Icons.arrow_back,
                color: ThemeColors.black80,
              ),
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: () {
              showConfirmBookingDialog();
            },
            child: Container(
              width: double.maxFinite,
              height: 48.0,
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                color: ThemeColors.primaryBlue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Confirm Booking',
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.black0),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SingleRowDetails(
                  title: 'Tipe Komunitas',
                  value: 'Berbayar',
                ),
                SingleRowDetails(
                  title: 'Durasi',
                  value: '1 Tahun',
                ),
                SingleRowDetails(
                  title: 'Berakhir Pada',
                  value:
                      '${DateHelper.formatDate(date: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day), format: 'dd MMM yyyy')}',
                ),
                Divider(
                  height: 1,
                  color: ThemeColors.black20,
                  thickness: 1.5,
                ),
                SingleRowDetails(
                  title: 'Komunitas',
                  value: '${getFormattedCurrency(int.parse(provider.price))}',
                ),
                SingleRowDetails(
                  title: 'Admin Fee',
                  value: 'IDR 0',
                ),
                SingleRowDetails(
                  title: 'Total Amount',
                  value: '${getFormattedCurrency(int.parse(provider.price))}',
                  isTotalAmount: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SingleRowDetails extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotalAmount;
  SingleRowDetails(
      {@required this.title, @required this.value, this.isTotalAmount = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$title',
            style: ThemeText.sfMediumFootnote.copyWith(
                color:
                    isTotalAmount ? ThemeColors.black100 : ThemeColors.black80),
          ),
          Text(
            '$value',
            style: ThemeText.sfMediumFootnote,
          )
        ],
      ),
    );
  }
}
