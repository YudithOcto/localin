import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/model/community/community_create_request_model.dart';
import 'package:localin/presentation/community/community_create/widgets/community_confirmation_details_booking_section.dart';
import 'package:localin/presentation/community/community_create/widgets/community_confirmation_details_price_section.dart';
import 'package:localin/presentation/community/provider/create/community_type_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/presentation/transaction/community/transaction_community_detail_page.dart';
import 'package:localin/presentation/webview/transaction_webview.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import 'community_payment_successful_page.dart';

class CommunityConfirmationDetailsWidget extends StatelessWidget {
  final Function onBackPressed;
  final CommunityCreateRequestModel model;

  CommunityConfirmationDetailsWidget({Key key, this.onBackPressed, this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    showConfirmBookingDialog() async {
      CustomDialog.showCenteredLoadingDialog(context, message: 'Loading ...');
      final provider =
          Provider.of<CommunityTypeProvider>(context, listen: false);
      final response = await provider.createEditCommunity(model: model);
      if (response.error == null) {
        CustomDialog.closeDialog(context);
        if (response.detailCommunity.transactionId == null ||
            response.detailCommunity.transactionId.isEmpty) {
          Navigator.of(context)
              .pushNamed(CommunityPaymentSuccessfulPage.routeName, arguments: {
            CommunityPaymentSuccessfulPage.communityData:
                response.detailCommunity
          });
        } else {
          CustomDialog.showLoadingDialog(context, message: 'Please wait');
          final result = await provider
              .payTransaction(response.detailCommunity.transactionId);
          CustomDialog.closeDialog(context);
          final payment = await Navigator.of(context)
              .pushNamed(TransactionWebView.routeName, arguments: {
            TransactionWebView.urlName: result?.urlRedirect,
            TransactionWebView.title: 'Transaction Community',
          });
          if (payment != null && payment == SUCCESS_VERIFICATION) {
            Navigator.of(context).pushNamed(
                CommunityPaymentSuccessfulPage.routeName,
                arguments: {
                  CommunityPaymentSuccessfulPage.communityData:
                      response.detailCommunity
                });
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                TransactionCommunityDetailPage.routeName, (route) => false,
                arguments: {
                  TransactionCommunityDetailPage.transactionId:
                      response?.detailCommunity?.transactionId,
                  TransactionCommunityDetailPage.onBackPressedHome: true,
                  TransactionCommunityDetailPage.communitySlug:
                      response?.detailCommunity?.slug
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

    return Scaffold(
      backgroundColor: ThemeColors.black10,
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
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
            color: ThemeColors.primaryBlue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Pay Now',
              style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
              child: Subtitle(
                title: 'Booking Details',
              ),
            ),
            ConfirmationDetailsBookingSection(
              communityName: model?.communityName,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 20.0),
              child: Subtitle(
                title: 'Price Details',
              ),
            ),
            CommunityConfirmationDetailsPriceSection(),
          ],
        ),
      ),
    );
  }
}

class SingleRowDetail extends StatelessWidget {
  final String title;
  final Widget value;

  SingleRowDetail({@required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: ThemeColors.black10,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: ThemeText.sfSemiBoldFootnote,
          ),
          value,
        ],
      ),
    );
  }
}
