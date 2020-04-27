import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/revamp/page/user_profile/revamp_profile_page.dart';
import 'package:localin/utils/constants.dart';

import '../../../../../text_themes.dart';
import '../../../../../themes.dart';

class RevampUserVerificationSuccessPage extends StatelessWidget {
  static const routeName = 'revampUserVerificationSuccess';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeColors.black0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(RevampProfilePage.routeName));
          },
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: Text(
          'Request Verification',
          style: ThemeText.sfMediumHeadline,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Verification Request Submitted',
              style: ThemeText.sfSemiBoldHeadline
                  .copyWith(color: ThemeColors.primaryBlue),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              '$kUserProfileVerifiedSubmitted',
              style: ThemeText.sfRegularBody,
            )
          ],
        ),
      ),
    );
  }
}
