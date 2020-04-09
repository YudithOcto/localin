import 'package:flutter/material.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/presentation/login/widgets/list_form_verification_widget.dart';

import '../../text_themes.dart';
import '../../themes.dart';

class RevampPhoneVerificationCodePage extends StatefulWidget {
  @override
  _RevampPhoneVerificationCodePageState createState() =>
      _RevampPhoneVerificationCodePageState();
}

class _RevampPhoneVerificationCodePageState
    extends State<RevampPhoneVerificationCodePage> {
  bool _isLoading = false;
  Color color;
  @override
  Widget build(BuildContext context) {
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
                      text: '08876287323',
                      style: ThemeText.sfRegularBody.copyWith(height: 1.5)),
                ]),
              ),
              SizedBox(height: 28.0),
              ListFormVerificationWidget(
                length: 4,
                color: color,
                valueChanged: (value) {
                  setState(() {
                    _isLoading = true;
                    color = ThemeColors.black10;
                  });
                  Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      _isLoading = false;
                      color = ThemeColors.black0;
                    });
                  });
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Request new code ${_isLoading ? 'in ' : ''}',
                    style: ThemeText.sfMediumBody
                        .copyWith(color: ThemeColors.black60),
                  ),
                  Visibility(
                    visible: true,
                    child: Text(
                      '00:32',
                      textAlign: TextAlign.center,
                      style: ThemeText.sfMediumBody
                          .copyWith(color: ThemeColors.black100),
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
          textTheme: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
          backgroundColor: ThemeColors.primaryBlue,
          isLoading: _isLoading,
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                _isLoading = false;
              });
            });
          },
        )
      ],
    );
  }
}
