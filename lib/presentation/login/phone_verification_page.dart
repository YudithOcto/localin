import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneVerificationPage extends StatefulWidget {
  static const routeName = '/phoneVerificationPage';
  static const phone = '/phone';
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  Timer _timer;
  bool _enable = true;
  int _seconds = 10;
  String _verifyStr = '';

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
        _verifyStr = 'Resend';
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.keyboard_backspace,
                color: Colors.black,
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
                  Expanded(flex: 2, child: TextFormField()),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          if (_enable) {
                            _startTimer();
                          }
                        },
                        child: Text(
                          '$_verifyStr',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              InkWell(
                onTap: () {
                  setState(() {});
                },
                child: Text(
                  'Kirim Lagi',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
