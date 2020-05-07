import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image.asset(
              'images/404_image.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            Text(
              'Coming Soon',
              textAlign: TextAlign.center,
              style: ThemeText.sfSemiBoldHeadline
                  .copyWith(color: ThemeColors.black80),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              'We are building beautiful features for you',
              textAlign: TextAlign.center,
              style:
                  ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
            ),
          ],
        ),
      ),
    );
  }
}
