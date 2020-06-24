import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/model/community/community_create_request_model.dart';
import 'package:localin/presentation/community/provider/create/community_type_provider.dart';
import 'package:localin/presentation/transaction/community/transaction_community_detail_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

import '../community_detail/community_detail_page.dart';

class CommunityTypePage extends StatelessWidget {
  static const routeName = 'CommunityType';
  static const requestModel = 'RequestModel';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommunityTypeProvider>(
      create: (_) => CommunityTypeProvider(),
      child: CommunityTypeCreateContent(),
    );
  }
}

class CommunityTypeCreateContent extends StatefulWidget {
  @override
  _CommunityTypeCreateContentState createState() =>
      _CommunityTypeCreateContentState();
}

class _CommunityTypeCreateContentState
    extends State<CommunityTypeCreateContent> {
  createCommunity({@required String type}) async {
    final result = await CustomDialog.showCustomDialogWithMultipleButton(
        context,
        title: 'Confirm Membership',
        message: 'I\'m sure to process this payment',
        cancelText: 'Cancel',
        onCancel: () => Navigator.of(context).pop(),
        okCallback: () => Navigator.of(context).pop(true),
        okText: 'Yes');
    if (result != null && result) {
      CustomDialog.showCenteredLoadingDialog(context, message: 'Loading ...');
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      CommunityCreateRequestModel model =
          routeArgs[CommunityTypePage.requestModel];
      final response =
          await Provider.of<CommunityTypeProvider>(context, listen: false)
              .createCommunity(type: type, model: model);
      if (response.error == null) {
        CustomDialog.closeDialog(context);
        if (response.detailCommunity.transactionId == null ||
            response.detailCommunity.transactionId.isEmpty) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              CommunityDetailPage.routeName, (route) => false,
              arguments: {
                CommunityDetailPage.communitySlug:
                    response.detailCommunity.slug,
                CommunityDetailPage.needBackToHome: true,
              });
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              TransactionCommunityDetailPage.routeName, (route) => false,
              arguments: {
                TransactionCommunityDetailPage.transactionId:
                    response.detailCommunity.transactionId,
                TransactionCommunityDetailPage.onBackPressedHome: true,
                TransactionCommunityDetailPage.communitySlug:
                    response.detailCommunity.slug,
              });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: RaisedButton(
        onPressed: () => createCommunity(type: 'paid'),
        color: ThemeColors.black0,
        elevation: 0.0,
        child: Text(
          'Start paid community',
          style:
              ThemeText.rodinaTitle3.copyWith(color: ThemeColors.primaryBlue),
        ),
      ),
      body: FutureBuilder<String>(
          future: Provider.of<CommunityTypeProvider>(context, listen: false)
              .getCommunityPrice(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1F75E1),
                    Color(0xFF094AAC),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 18.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.arrow_back,
                              color: ThemeColors.black0,
                            ),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            'Membership',
                            style: ThemeText.sfMediumHeadline
                                .copyWith(color: ThemeColors.black0),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () => createCommunity(type: 'free'),
                            child: Text('Continue with free',
                                style: ThemeText.sfMediumHeadline
                                    .copyWith(color: ThemeColors.black0)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 36.0,
                      ),
                      SvgPicture.asset(
                        'images/illustration.svg',
                        width: double.infinity,
                        height: 260.0,
                      ),
                      SizedBox(
                        height: 36.0,
                      ),
                      Text(
                        'Go Paid Community and create event for your audience',
                        textAlign: TextAlign.center,
                        style: ThemeText.rodinaTitle2
                            .copyWith(color: ThemeColors.black0),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Container(
                        height: 84,
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: ThemeColors.yellow,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset('images/circle_checked_white.svg'),
                            SizedBox(
                              width: 18.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Upgrade to paid community',
                                  style: ThemeText.sfMediumBody,
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  '${getFormattedCurrency(int.parse(snapshot.data))}/year',
                                  style: ThemeText.sfSemiBoldTitle3,
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
