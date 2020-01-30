import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../themes.dart';

class PhoneVerificationPage extends StatefulWidget {
  static const routeName = '/phoneVerificationPage';
  static const phone = '/phone';
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  Timer _timer;
  int _seconds = 120, verifyTryCount = 0;
  String _verifyStr = '', _phoneNumber = '', _smsCode = '';
  Repository _repository = Repository();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false, _isInit = true, _enable = true;

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = 120;
        _enable = true;
        _verifyStr = '';
        setState(() {});
        return;
      }

      _enable = false;
      _seconds--;
      _verifyStr = '${_seconds}s';
      setState(() {});
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _phoneNumber = routeArgs[PhoneVerificationPage.phone];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.black,
                ),
              ),
              Image.asset(
                'images/phone_verify.png',
                scale: 5.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Kode Verifikasi Telat Dikirim!',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Masukkan kode yang kami SMS ke nomor HP-mu yang terdaftar di',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Form(
                      key: formKey,
                      autovalidate: autoValidate,
                      child: TextFormField(
                        validator: (value) => value == null && value.isEmpty
                            ? 'Required field'
                            : null,
                        onSaved: (value) {
                          _smsCode = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '$_verifyStr',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: <Widget>[
                  Builder(
                    builder: (ctx) {
                      return FlatButton(
                        onPressed: () async {
                          if (validateInput()) {
                            final response = await verifySmsCode();
                            if (response?.error == null) {
                              Scaffold.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('${response?.message}'),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              );

                              /// TODO: call api get me, update cache on auth provider, then redirect to homepage
                            } else {
                              Scaffold.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('${response?.error}'),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Verify',
                          style: TextStyle(
                              color: Themes.primaryBlue,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600),
                        ),
                      );
                    },
                  ),
                  Builder(
                    builder: (ctx) {
                      return InkWell(
                        onTap: () async {
                          if (_enable && verifyTryCount <= 3) {
                            final response = await userVerifyPhoneRequest();
                            if (response.error == null) {
                              _startTimer();
                              verifyTryCount += 1;
                            } else {
                              Scaffold.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('${response?.error}'),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              );
                            }
                          } else {
                            if (verifyTryCount > 3) {
                              Scaffold.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Anda sudah mencapai limit percobaan, silahkan masukkan nomor lain di halaman sebelumnya.'),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Kirim Lagi',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserBaseModel> userVerifyPhoneRequest() async {
    if (!_phoneNumber.startsWith('0')) {
      _phoneNumber = '0$_phoneNumber';
    }
    final response =
        await _repository.userPhoneRequestCode(int.parse(_phoneNumber));
    return response;
  }

  Future<UserBaseModel> verifySmsCode() async {
    final response =
        await _repository.verifyPhoneVerificationCode(int.parse(_smsCode));
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
