import 'package:flutter/material.dart';

import '../text_themes.dart';
import '../themes.dart';

class CustomDialog {
  static Future<void> showLoadingDialog(BuildContext context,
      {String message = 'Signing you in and loading your data'}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              content: Row(
                children: <Widget>[
                  Container(
                      width: 36.0,
                      height: 36.0,
                      child: CircularProgressIndicator()),
                  SizedBox(
                    width: 17.0,
                  ),
                  Expanded(
                    child: Text('$message',
                        style: ThemeText.sfMediumBody
                            .copyWith(color: ThemeColors.black80)),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
