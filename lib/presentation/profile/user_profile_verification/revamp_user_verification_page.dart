import 'package:flutter/material.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/profile/provider/revamp_verification_provider.dart';
import 'package:localin/presentation/profile/user_profile_verification/row_user_profile_form_widget.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_success_page.dart';
import 'package:localin/provider/core/image_picker_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class RevampUserVerificationPage extends StatelessWidget {
  static const routeName = '/userprofileverificationpage';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RevampVerificationProvider>(
          create: (_) => RevampVerificationProvider(),
        ),
        ChangeNotifierProvider<ImagePickerProvider>(
          create: (_) => ImagePickerProvider(),
        )
      ],
      child: ProfileVerificationPage(),
    );
  }
}

class ProfileVerificationPage extends StatefulWidget {
  @override
  _ProfileVerificationPageState createState() =>
      _ProfileVerificationPageState();
}

class _ProfileVerificationPageState extends State<ProfileVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeColors.black0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 70),
              children: <Widget>[
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Apply for Localin Verification',
                    style: ThemeText.sfSemiBoldHeadline
                        .copyWith(color: ThemeColors.brandBlack),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    kRequstVerificationContentText,
                    style: ThemeText.sfRegularBody
                        .copyWith(color: ThemeColors.brandBlack),
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                RowUserProfileFormWidget(),
              ],
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Consumer<RevampVerificationProvider>(
              builder: (context, provider, child) {
                return StreamBuilder<bool>(
                    stream: Provider.of<RevampVerificationProvider>(context)
                        .sendButtonState,
                    builder: (context, snapshot) {
                      return Container(
                          width: double.infinity,
                          height: 48.0,
                          child: RaisedButton(
                            onPressed: () async {
                              final validation = provider.validateInput;
                              if (validation.isEmpty) {
                                CustomDialog.showLoadingDialog(context,
                                    message: 'Sending data');
                                final result =
                                    await provider.verifyUserAccount();
                                if (result.error.isEmpty) {
                                  Navigator.of(context).popAndPushNamed(
                                      RevampUserVerificationSuccessPage
                                          .routeName);
                                } else {
                                  CustomToast.showCustomToast(
                                      context, '${result?.message}');
                                }
                                CustomDialog.closeDialog(context);
                              } else {
                                CustomToast.showCustomToast(
                                    context, '$validation');
                              }
                            },
                            color: snapshot.hasData && snapshot.data
                                ? ThemeColors.primaryBlue
                                : ThemeColors.black10,
                            child: Text(
                              'Send Request',
                              style: ThemeText.rodinaTitle3.copyWith(
                                  color: snapshot.hasData && snapshot.data
                                      ? ThemeColors.black0
                                      : ThemeColors.black60),
                            ),
                          ));
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
