import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

import '../community_detail/community_detail_page.dart';

class CommunityTypePage extends StatefulWidget {
  static const routeName = 'CommunityType';

  @override
  _CommunityTypePageState createState() => _CommunityTypePageState();
}

class _CommunityTypePageState extends State<CommunityTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: RaisedButton(
        onPressed: () async {
          final result = await CustomDialog.showCustomDialogWithMultipleButton(
              context,
              title: 'Confirm Membership',
              message: 'I\'m sure to process this payment',
              cancelText: 'Cancel',
              onCancel: () => Navigator.of(context).pop(),
              okCallback: () => Navigator.of(context).pop(true),
              okText: 'Yes');
          if (result != null && result) {
            CustomDialog.showCenteredLoadingDialog(context,
                message: 'Loading ...');
            Future.delayed(Duration(seconds: 2), () {
              CustomDialog.closeDialog(context);
              Navigator.of(context).pushNamed(CommunityDetailPage.routeName,
                  arguments: {
                    CommunityDetailPage.communityData: CommunityDetail()
                  });
            });
          }
        },
        color: ThemeColors.black0,
        elevation: 0.0,
        child: Text(
          'Start paid community',
          style:
              ThemeText.rodinaTitle3.copyWith(color: ThemeColors.primaryBlue),
        ),
      ),
      body: Container(
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back,
                      color: ThemeColors.black0,
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
                    Text('Continue with free',
                        style: ThemeText.sfMediumHeadline
                            .copyWith(color: ThemeColors.black0))
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
                            'IDR 49,000/year',
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
      ),
    );
  }
}
