import 'package:flutter/material.dart';

class PhoneVerificationPage extends StatefulWidget {
  static const routeName = '/phoneVerify';
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5.0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Image.asset(
          'images/app_bar_logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
          height: 50.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: size.width * 0.4,
              height: size.height * 0.2,
              child: Image.asset(
                'images/phone_auth.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Masukkan No Hp'),
            ),
            Row(
              children: <Widget>[
                Text('+62'),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: TextFormField(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
