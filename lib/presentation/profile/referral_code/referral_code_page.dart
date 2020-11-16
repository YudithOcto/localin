import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/model/user/user_referral_response.dart';
import 'package:localin/presentation/profile/provider/referral_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ReferralCodePage extends StatelessWidget {
  static const routeName = 'ReferralCodePage';
  static const referralCode = 'ReferralCode';

  @override
  Widget build(BuildContext context) {
    final route =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String referral = route[referralCode];
    return ChangeNotifierProvider<ReferralProvider>(
      create: (_) => ReferralProvider(),
      child: LayoutBuilder(
        builder: (_, constraint) => Scaffold(
          appBar: CustomAppBar(
            appBar: AppBar(),
            pageTitle: 'Referral',
            onClickBackButton: () => Navigator.of(context).pop(),
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 33.0, horizontal: 20.0),
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
                        'Hai, udah cobain Localin belum? Kayaknya kamu bakal suka, soalnya Localin #BisaDiandelin. '
                            'Yuk, buktiin sendiri dan install aplikasinya di sini, masukkan Kode $referral untuk mendapatkan '
                            '20000 Local Poin.',
                        'text/plain');
                  },
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  title: 'Invite Friends',
                  height: 48.0,
                  needCenter: true,
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.black0),
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
                Consumer<ReferralProvider>(
                  builder: (_, provider, __) => TextFormField(
                    controller: provider.referralEditTextController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12.0),
                      hintText: 'eg: LOC123',
                      hintStyle: ThemeText.rodinaTitle3
                          .copyWith(color: ThemeColors.black60),
                      suffixIcon: InkResponse(
                        onTap: () async {
                          if (provider.isTextNotEmpty) {
                            UserReferralResponse data =
                                await provider.inputReferral();
                            FocusScope.of(context).unfocus();
                            if (data != null && !data.error) {
                              CustomToast.showCustomToastWhite(
                                  context, data?.message);
                            } else {
                              CustomToast.showCustomToastWhite(
                                  context, data?.message);
                            }
                          }
                        },
                        child: SvgPicture.asset(
                          'images/icon_enter.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
