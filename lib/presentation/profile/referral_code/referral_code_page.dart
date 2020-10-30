import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/custom_member_text_form_field_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ReferralCodePage extends StatelessWidget {
  static const routeName = 'ReferralCodePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        pageTitle: 'Referral',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 33.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Let’s invite friends to try Localin!',
              style: ThemeText.sfSemiBoldHeadline,
            ),
            SizedBox(height: 8.0),
            Text(
              'So, they can benefit by experiencing Localin and its perks, just like You!',
              style: ThemeText.sfRegularBody,
            ),
            SizedBox(height: 33.0),
            RoundedButtonFill(
              onPressed: () {
                Share.text(
                    'Localin',
                    'You can use this referral code and get discount. LOC123',
                    'text/plain');
              },
              margin: const EdgeInsets.symmetric(horizontal: 32.0),
              title: 'Invite Friends',
              height: 48.0,
              needCenter: true,
              style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
            ),
            SizedBox(height: 33.0),
            Text(
              'Have a Referral Code?',
              style: ThemeText.sfSemiBoldHeadline,
            ),
            SizedBox(height: 8.0),
            Text(
              'Enter your referral code below to get Local Point',
              style: ThemeText.sfRegularBody,
            ),
            SizedBox(height: 14.0),
            TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 12.0),
                hintText: 'eg: LOC123',
                hintStyle:
                    ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black60),
                suffixIcon: SvgPicture.asset(
                  'images/icon_enter.svg',
                  fit: BoxFit.cover,
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
