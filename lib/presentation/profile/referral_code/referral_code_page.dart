import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/model/user/user_referral_response.dart';
import 'package:localin/presentation/profile/provider/referral_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ReferralCodePage extends StatelessWidget {
  static const routeName = 'ReferralCodePage';
  static const userModel = 'UserModel';

  @override
  Widget build(BuildContext context) {
    final route =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    UserModel model = route[userModel];
    return ChangeNotifierProvider<ReferralProvider>(
      create: (_) => ReferralProvider(ref: model?.friendReferral),
      child: LayoutBuilder(
        builder: (context, constraint) => Scaffold(
          appBar: CustomAppBar(
            appBar: AppBar(),
            pageTitle: 'Referral',
            onClickBackButton: () {
              if (Provider.of<ReferralProvider>(context).statusSuccess) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
              }
            },
          ),
          body: WillPopScope(
            onWillPop: () async {
              if (Provider.of<ReferralProvider>(context).statusSuccess) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
              }
              return false;
            },
            child: Padding(
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
                              'Yuk, buktiin sendiri dan install aplikasinya di sini, masukkan Kode ${model?.userReferralCode ?? ''} untuk mendapatkan '
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
                      enabled: provider.statusSuccess ||
                              model.friendReferral.isNotEmpty
                          ? false
                          : true,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 12.0),
                        hintText: 'EG: LOC',
                        hintStyle: ThemeText.rodinaTitle3
                            .copyWith(color: ThemeColors.black60),
                        suffixIcon: InkResponse(
                          onTap: () async {
                            if (provider.isTextNotEmpty) {
                              UserReferralResponse data =
                                  await provider.inputReferral();
                              FocusScope.of(context).unfocus();
                              Provider.of<AuthProvider>(context, listen: false)
                                  .updateFriendReferral(
                                      provider.referralEditTextController.text);
                              CustomToast.showCustomToastWhite(
                                  context, data?.message);
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
      ),
    );
  }
}
