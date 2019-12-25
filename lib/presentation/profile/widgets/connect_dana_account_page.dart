import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';

class ConnectDanaAccountPage extends StatefulWidget {
  static const routeName = '/connectDana';
  @override
  _ConnectDanaAccountPageState createState() => _ConnectDanaAccountPageState();
}

class _ConnectDanaAccountPageState extends State<ConnectDanaAccountPage> {
  @override
  Widget build(BuildContext context) {
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
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        decoration: BoxDecoration(
            border: Border.all(color: Themes.primaryBlue),
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                'Enter your DANA Account',
                style: kValueStyle.copyWith(
                    fontSize: 50.0, color: Themes.primaryBlue),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                height: 60.0,
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: '+6281123456789',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Themes.primaryBlue),
                          borderRadius: BorderRadius.circular(12.0)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Themes.primaryBlue))),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                height: 60.0,
                child: RaisedButton(
                  onPressed: () {},
                  elevation: 5.0,
                  color: Themes.primaryBlue,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Themes.primaryBlue),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    'CONNECT',
                    style: kValueStyle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
