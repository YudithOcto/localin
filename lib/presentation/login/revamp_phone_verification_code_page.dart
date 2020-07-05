import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/components/custom_verification_code.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/login/providers/verify_code_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../locator.dart';
import '../../text_themes.dart';
import '../../themes.dart';

class RevampPhoneVerificationCodePage extends StatefulWidget {
  final String phoneNumber;
  RevampPhoneVerificationCodePage({this.phoneNumber});

  @override
  _RevampPhoneVerificationCodePageState createState() =>
      _RevampPhoneVerificationCodePageState();
}

class _RevampPhoneVerificationCodePageState
    extends State<RevampPhoneVerificationCodePage> {
  @override
  void initState() {
    locator<AnalyticsService>().setScreenName(name: 'VerifyPhoneCodePage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VerifyCodeProvider>(
      create: (_) => VerifyCodeProvider(),
      child: VerifyContentFormWidget(
          phoneNumber: widget.phoneNumber.validatedPhoneNumber),
    );
  }
}

class VerifyContentFormWidget extends StatelessWidget {
  final String phoneNumber;
  VerifyContentFormWidget({this.phoneNumber});
  @override
  Widget build(BuildContext context) {
    return Consumer<VerifyCodeProvider>(builder: (context, provider, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Verification Code',
                  style: ThemeText.rodinaTitle2
                      .copyWith(color: ThemeColors.black100),
                ),
                SizedBox(
                  height: 4.0,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Please type the verification code sent \nto ',
                        style: ThemeText.sfRegularBody
                            .copyWith(color: ThemeColors.black80)),
                    TextSpan(
                        text: '${phoneNumber.validatedPhoneNumber}',
                        style:
                            ThemeText.sfRegularFootnote.copyWith(height: 1.5)),
                  ]),
                ),
                Visibility(
                  visible: provider.timerState.isExpired,
                  child: Container(
                    margin: EdgeInsets.only(top: 16.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: ThemeColors.red10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Text(
                        'Code was expired! Please request a new code',
                        style: ThemeText.sfMediumFootnote
                            .copyWith(color: ThemeColors.red80),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: provider.timerState.defaultOrOnProgress,
                  child: SizedBox(height: 28.0),
                ),
                VerificationCode(
                  keyboardType: TextInputType.number,
                  onCompleted: (v) async {
                    provider.setFieldVerifyCode(v);
                    if (provider.isFormDisabled) {
                      customShowToast(context, 'You need to Request new code');
                    } else if (provider.isAllFieldsFilled) {
                      final response = await provider.verifySmsCode();
                      if (response.error != null) {
                        customShowToast(context, '${response.error}');
                        if (response.error.contains('ganti')) {
                          provider.disabledForm();
                        }
                      } else {
                        pushDataToLocalCache(context, provider);
                        Navigator.of(context).pushReplacementNamed(
                            MainBottomNavigation.routeName);
                      }
                    } else {
                      customShowToast(
                          context, 'You are required to fill in all fields');
                    }
                  },
                  onEditing: (isStillEditing) {
                    provider.setAllFieldsFilled(!isStillEditing);
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        /// Only after expired that user can request new code again
                        if (provider.timerState.isExpired) {
                          provider.enabledForm();
                          provider.requestingCodeBySms(phoneNumber);
                          provider.setAllFieldsFilled(false);
                          provider.clearTextFormField();
                        }
                      },
                      child: Text(
                        'Request new code ${provider.timerState.isOnProgress ? 'in ' : ''}',
                        style: ThemeText.sfMediumBody.copyWith(
                            color: provider.timerState.defaultOrOnProgress
                                ? ThemeColors.black60
                                : ThemeColors.primaryBlue),
                      ),
                    ),
                    Visibility(
                      visible: provider.timerState.isOnProgress,
                      child: Text(
                        '${provider?.currentDifference}',
                        textAlign: TextAlign.center,
                        style: ThemeText.sfMediumBody
                            .copyWith(color: ThemeColors.black100),
                      ),
                    ),
                    SizedBox(
                      width: 8.21,
                    ),
                    Visibility(
                      visible: provider.requestingNewSmSCode,
                      child: Container(
                        width: 11.57,
                        height: 11.57,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
          FilledButtonDefault(
            buttonText: 'Submit',
            textTheme:
                ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
            backgroundColor: ThemeColors.primaryBlue,
            isLoading: provider.isVerifyCodeNumber,
            onPressed: () async {
              if (provider.isFormDisabled) {
                customShowToast(context, 'You need to Request new code');
              } else if (provider.isAllFieldsFilled) {
                final response = await provider.verifySmsCode();
                if (response.error != null) {
                  customShowToast(context, '${response.error}');
                  if (response.error.contains('ganti')) {
                    provider.disabledForm();
                  }
                } else {
                  pushDataToLocalCache(context, provider);
                  Navigator.of(context)
                      .pushReplacementNamed(MainBottomNavigation.routeName);
                }
              } else {
                customShowToast(
                    context, 'You are required to fill in all fields');
              }
            },
          )
        ],
      );
    });
  }

  pushDataToLocalCache(
      BuildContext context, VerifyCodeProvider provider) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(kUserVerify, true);
    Provider.of<AuthProvider>(context, listen: false)
        .updateUserModelAndCache(phoneNumber);
  }

  customShowToast(BuildContext context, String message) {
    showToast('$message',
        context: context,
        position: StyledToastPosition(offset: 70.0, align: Alignment.center),
        textStyle:
            ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.red80),
        backgroundColor: ThemeColors.red10);
  }
}

extension on String {
  String get validatedPhoneNumber {
    if (this.startsWith('0')) {
      return '+62${this.substring(1, this.length)}';
    } else if (this.startsWith('+62')) {
      return this;
    } else {
      return '+62$this';
    }
  }
}

extension on TimerState {
  bool get isOnProgress {
    return this == TimerState.Progress;
  }

  bool get isExpired {
    return this == TimerState.Expired;
  }

  bool get isNotStart {
    return this == TimerState.Default;
  }

  bool get defaultOrOnProgress {
    return this == TimerState.Default || this == TimerState.Progress;
  }
}
