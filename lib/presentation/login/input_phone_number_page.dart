import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/login/providers/input_phone_number_provider.dart';
import 'package:localin/presentation/login/revamp_phone_verification_code_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

import '../../text_themes.dart';

class InputPhoneNumberPage extends StatefulWidget {
  static const routeName = 'VerifyPhoneNumberPage';
  static const userPhoneVerificationCode = 'userPhoneVerificationCode';

  @override
  _InputPhoneNumberPageState createState() => _InputPhoneNumberPageState();
}

class _InputPhoneNumberPageState extends State<InputPhoneNumberPage> {
  @override
  void initState() {
    locator<AnalyticsService>().setScreenName(name: 'InputPhoneNumberPage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String openVerificationCode =
        routeArgs[InputPhoneNumberPage.userPhoneVerificationCode];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          onTap: _onWillPop,
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<InputPhoneNumberProvider>(
            create: (_) => InputPhoneNumberProvider(),
          ),
        ],
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: ColumnContent(
            isVerificationCodeOpen: openVerificationCode,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit app?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No')),
              FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              )
            ],
          ),
        ) ??
        false;
  }
}

class ColumnContent extends StatefulWidget {
  final String isVerificationCodeOpen;

  ColumnContent({this.isVerificationCodeOpen});

  @override
  _ColumnContentState createState() => _ColumnContentState();
}

class _ColumnContentState extends State<ColumnContent> {
  final inputPhoneNumberBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: BorderSide(color: ThemeColors.black10));
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      if (widget.isVerificationCodeOpen.isNotNullOrNotEmpty) {
        Provider.of<InputPhoneNumberProvider>(context, listen: false)
                .phoneNumberController
                .text =
            widget.isVerificationCodeOpen
                .substring(1, widget.isVerificationCodeOpen.length);
        openVerificationCodePage(context,
            phoneNumber: widget.isVerificationCodeOpen);
      }
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InputPhoneNumberProvider>(
      builder: (_, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 12.0, left: 20.0, right: 20.0),
              child: Text(
                'Phone Number',
                style: ThemeText.rodinaHeadline,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 8.0, bottom: 20.0, left: 20.0, right: 20.0),
              child: Text(
                'Please enter your phone number to complete your registration',
                style: ThemeText.sfRegularBody
                    .copyWith(color: ThemeColors.black80),
              ),
            ),
            Form(
              key: provider.formKey,
              autovalidate: provider.autoValidateForm,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      splashColor: provider.isLoading
                          ? ThemeColors.black10
                          : ThemeColors.black0),
                  child: TextFormField(
                    enabled: !provider.isLoading,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) =>
                        value.isEmpty ? 'Phone number is required' : null,
                    controller: provider.phoneNumberController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    style: ThemeText.rodinaBody.copyWith(
                        color: provider.isLoading
                            ? ThemeColors.black60
                            : ThemeColors.black100),
                    decoration: InputDecoration(
                        fillColor: provider.isLoading
                            ? ThemeColors.black10
                            : ThemeColors.black0,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                        prefixIcon: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4.0),
                          margin: EdgeInsets.fromLTRB(20.0, 16.0, 8.0, 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: provider.isLoading
                                ? ThemeColors.black40
                                : ThemeColors.orange10,
                          ),
                          child: Text(
                            '+62',
                            style: ThemeText.rodinaFootnote.copyWith(
                                color: provider.isLoading
                                    ? ThemeColors.black60
                                    : ThemeColors.orange80),
                          ),
                        ),
                        focusedBorder: inputPhoneNumberBorder,
                        border: inputPhoneNumberBorder,
                        enabledBorder: inputPhoneNumberBorder,
                        disabledBorder: inputPhoneNumberBorder,
                        hintText: 'Enter your phone number',
                        hintStyle: ThemeText.rodinaBody
                            .copyWith(color: ThemeColors.black60)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Builder(
                  builder: (ctx) => Container(
                    width: double.infinity,
                    height: 48.0,
                    child: RaisedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        String validateRegex =
                            validateMobile(provider.phoneNumberController.text);
                        if (validateRegex != null) {
                          showToast(validateRegex,
                              context: context,
                              position: StyledToastPosition(
                                  offset: 70.0, align: Alignment.bottomCenter),
                              textStyle: ThemeText.sfMediumFootnote
                                  .copyWith(color: ThemeColors.red80),
                              backgroundColor: ThemeColors.red10);
                        } else {
                          final isSuccess = await provider.validateInput();
                          if (isSuccess) {
                            final result = await provider.userPhoneRequest();
                            if (result.isNotEmpty) {
                              provider.setLoading();
                              showToast(result,
                                  context: context,
                                  position: StyledToastPosition(
                                      offset: 70.0,
                                      align: Alignment.bottomCenter),
                                  textStyle: ThemeText.sfMediumFootnote
                                      .copyWith(color: ThemeColors.red80),
                                  backgroundColor: ThemeColors.red10);
                            } else {
                              openVerificationCodePage(context,
                                  phoneNumber:
                                      provider?.phoneNumberController?.text);
                              provider.setLoading();
                            }
                          }
                        }
                      },
                      color: ThemeColors.primaryBlue,
                      child: provider.isLoading
                          ? Container(
                              alignment: FractionalOffset.center,
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ThemeColors.black10),
                                strokeWidth: 3.0,
                              ),
                            )
                          : Text(
                              'Continue',
                              style: ThemeText.rodinaBody
                                  .copyWith(color: ThemeColors.black0),
                            ),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  openVerificationCodePage(BuildContext context, {String phoneNumber}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userCache =
          await Provider.of<AuthProvider>(context).getUserFromCache();
      await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: ThemeColors.black0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0))),
          builder: (context) => SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: RevampPhoneVerificationCodePage(
                      phoneNumber: phoneNumber != null
                          ? phoneNumber
                          : userCache?.handphone,
                    )),
              ));
    });
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}

extension on String {
  bool get isNotNullOrNotEmpty {
    return this != null && this.isNotEmpty;
  }

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
