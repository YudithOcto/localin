import 'package:flutter/material.dart';

import '../../themes.dart';

class SuccessBookingPage extends StatefulWidget {
  static const routeName = '/successBookingPage';
  @override
  _SuccessBookingPageState createState() => _SuccessBookingPageState();
}

class _SuccessBookingPageState extends State<SuccessBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Themes.primaryBlue,
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
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
              Center(
                child: Image.asset(
                  'images/success_icon.png',
                  scale: 2.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  'Success! Your stay is confirmed',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Center(
                child: Text(
                  'Booking ID: NYDHO123',
                  style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
              CustomRoundedButton(),
              DetailCard(),
            ],
          ),
        ));
  }
}

class CustomRoundedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Check in time 01:30 PM onwards',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
            Text(
              'Update',
              style: TextStyle(
                  fontSize: 11.0,
                  color: Themes.primaryBlue,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: <Widget>[
          customGreenIcon(),
          SizedBox(
            height: 10.0,
          ),
          customText('Person 1'),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              customText('Wed, 01 Jan'),
              SizedBox(
                width: 15.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2.0)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '1N',
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              customText('Thur, 02 Jan'),
            ],
          ),
          customDivider(),
        ],
      ),
    );
  }

  Widget customDivider() {
    return Container(
      color: Colors.black38,
      width: double.infinity,
      height: 1.0,
      margin: EdgeInsets.symmetric(vertical: 20.0),
    );
  }

  Widget customGreenIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.only(top: 5.0),
        decoration: BoxDecoration(
            color: Themes.green, borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Want to save more on this booking?',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
              Icon(Icons.keyboard_arrow_right, color: Colors.white)
            ],
          ),
        ),
      ),
    );
  }

  Widget customText(String value) {
    return Text(
      value,
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black87),
    );
  }
}

class SecondLevelDetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row();
  }
}
