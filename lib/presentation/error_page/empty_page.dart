import 'package:flutter/material.dart';
import 'package:localin/utils/constants.dart';
import '../../themes.dart';

class EmptyPage extends StatelessWidget {
  static const routeName = '/emptyPage';
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'images/404_image.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          ),
          Text(
            '404',
            style: kValueStyle.copyWith(
                fontSize: 40.0, color: ThemeColors.primaryBlue),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Oops. Page akan segera datang',
            style: kValueStyle.copyWith(
                fontSize: 20.0,
                color: ThemeColors.primaryBlue,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 35.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Kami akan berusaha membantu kamu mencari jalan keluar. Karena halaman ini belum tersedia',
              textAlign: TextAlign.center,
              style: kValueStyle.copyWith(
                  fontSize: 16.0,
                  color: ThemeColors.primaryBlue,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
