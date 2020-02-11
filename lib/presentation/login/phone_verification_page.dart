import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/login/input_phone_number.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes.dart';

class PhoneVerificationPage extends StatefulWidget {
  static const routeName = '/phoneVerificationPage';
  static const phone = '/phone';
  static const isBackButtonActive = '/activateBackButton';
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  Timer _timer;
  int _seconds = 120, verifyTryCount = 0;
  String _verifyStr = '', _phoneNumber = '', _smsCode = '';
  Repository _repository = Repository();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false,
      _isInit = true,
      _enable = true,
      _isBackButtonActive = true;

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  _cancelTimer() {
    if (_timer != null && _timer.isActive) {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = 120;
        _enable = true;
        _verifyStr = '';
        if (mounted) {
          setState(() {});
        }

        return;
      }

      _enable = false;
      _seconds--;
      _verifyStr = '${_seconds}s';
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _phoneNumber = routeArgs[PhoneVerificationPage.phone];
      _isBackButtonActive = routeArgs[PhoneVerificationPage.isBackButtonActive];
      if (!_isBackButtonActive) {
        _startTimer();
      } else {
        _startTimer();
      }
      _isInit = false;
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
                  Navigator.of(context)
                      .pushReplacementNamed(InputPhoneNumber.routeName);
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
                'Kode Verifikasi Telah Dikirim!',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Masukkan kode yang kami SMS ke nomor HP-mu yang terdaftar di ${_phoneNumber.startsWith('0') ? _phoneNumber : '0$_phoneNumber'}',
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
                            if (response.isError != null && !response.isError) {
                              final save =
                                  await SharedPreferences.getInstance();
                              save.setBool(kUserVerify, true);
                              Scaffold.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('${response?.message}'),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              );
                              Provider.of<AuthProvider>(context)
                                  .updateUserModelAndCache(_phoneNumber);
                              Navigator.of(context).pushReplacementNamed(
                                  MainBottomNavigation.routeName);
                              _cancelTimer();
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
                            } else {
                              SnackBar(
                                content: Text(
                                    'Anda diharuskan menunggu $_verifyStr detik lagi'),
                                duration: Duration(milliseconds: 1000),
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
    print('COUNT');
    if (!_phoneNumber.startsWith('0')) {
      _phoneNumber = '0$_phoneNumber';
    }
    final response = await _repository.userPhoneRequestCode(_phoneNumber);
    return response;
  }

  Future<UserBaseModel> verifySmsCode() async {
    var response;
    try {
      response =
          await _repository.verifyPhoneVerificationCode(int.parse(_smsCode));
    } catch (error) {
      response = UserBaseModel.withError('Kode sms tidak boleh kosong');
    }

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
