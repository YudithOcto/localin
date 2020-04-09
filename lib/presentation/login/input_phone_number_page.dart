import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/presentation/login/revamp_phone_verification_code_page.dart';
import 'package:localin/themes.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import '../../text_themes.dart';

class InputPhoneNumberPage extends StatefulWidget {
  static const routeName = '/phoneVerify';
  @override
  _InputPhoneNumberPageState createState() => _InputPhoneNumberPageState();
}

class _InputPhoneNumberPageState extends State<InputPhoneNumberPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  String _phoneNumber = '';
  Repository _repository = Repository();
  bool _isLoading = false;

  final inputPhoneNumberBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.0),
      borderSide: BorderSide(color: ThemeColors.black10));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Icon(
          Icons.arrow_back,
          color: ThemeColors.black80,
        ),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Column(
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
              style:
                  ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
            ),
          ),
          Form(
            key: formKey,
            autovalidate: autoValidate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                    splashColor:
                        _isLoading ? ThemeColors.black10 : ThemeColors.black0),
                child: TextFormField(
                  enabled: !_isLoading,
                  validator: (value) =>
                      value.isEmpty ? 'This field required' : null,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.phone,
                  style: ThemeText.rodinaBody.copyWith(
                      color: _isLoading
                          ? ThemeColors.black60
                          : ThemeColors.black100),
                  decoration: InputDecoration(
                      fillColor:
                          _isLoading ? ThemeColors.black10 : ThemeColors.black0,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                      prefixIcon: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        margin: EdgeInsets.fromLTRB(20.0, 16.0, 8.0, 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: _isLoading
                              ? ThemeColors.black40
                              : ThemeColors.orange10,
                        ),
                        child: Text(
                          '+62',
                          style: ThemeText.rodinaFootnote.copyWith(
                              color: _isLoading
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
                  onSaved: (value) {
                    _phoneNumber = value;
                  },
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
                      setState(() {
                        _isLoading = true;
                      });
                      if (validateInput()) {
                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            _isLoading = false;
                          });
                          showModalBottomSheet(
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
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child:
                                            RevampPhoneVerificationCodePage()),
                                  ));
                        });
//                        final result = await userPhoneRequest();
//                        if (result != null && result.error == null) {
//                          setState(() {
//                            _isLoading = false;
//                          });
//                          Navigator.of(ctx).pushReplacementNamed(
//                              PhoneVerificationPage.routeName,
//                              arguments: {
//                                PhoneVerificationPage.phone: _phoneNumber,
//                                PhoneVerificationPage.isBackButtonActive: true,
//                              });
//                        } else {
//                          Scaffold.of(ctx).showSnackBar(SnackBar(
//                            content: Text('${result?.error}'),
//                          ));
//                          setState(() {
//                            _isLoading = false;
//                          });
//                        }
                      } else {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    color: ThemeColors.primaryBlue,
                    child: _isLoading
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
      ),
    );
  }

  Future<UserBaseModel> userPhoneRequest() async {
    if (!_phoneNumber.startsWith('0')) {
      this._phoneNumber = '0$_phoneNumber';
    }
    final response = await _repository.userPhoneRequestCode(_phoneNumber);
    return response;
  }

  bool validateInput() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      setState(() {
        autoValidate = true;
      });
      return false;
    }
  }
}
