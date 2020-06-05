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

  static Future<void> showCenteredLoadingDialog(BuildContext context,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 36.0,
                      height: 36.0,
                      child: CircularProgressIndicator()),
                  SizedBox(
                    width: 12.5,
                  ),
                  Text('$message',
                      style: ThemeText.rodinaHeadline
                          .copyWith(color: ThemeColors.black80)),
                ],
              ),
            ),
          );
        });
  }

  static Future<T> showCustomDialogWithMultipleButton<T>(BuildContext context,
      {@required String title,
      String message,
      @required String cancelText,
      @required String okText,
      bool isDismissible = true,
      Color cancelBtnColor = ThemeColors.black0,
      Color cancelTxtColor = ThemeColors.primaryBlue,
      Color okBtnColor = ThemeColors.primaryBlue,
      Color okTxtColor = ThemeColors.black0,
      VoidCallback onCancel,
      VoidCallback okCallback}) async {
    return showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => isDismissible,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '$title',
                    style: ThemeText.sfMediumTitle3,
                  ),
                  SizedBox(height: 8.0),
                  Text('$message',
                      textAlign: TextAlign.center,
                      style: ThemeText.sfRegularBody.copyWith(
                          color: ThemeColors.black80,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: onCancel,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: ThemeColors.black40),
                                color: cancelBtnColor,
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                '$cancelText',
                                textAlign: TextAlign.center,
                                style: ThemeText.rodinaTitle3
                                    .copyWith(color: cancelTxtColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7.0,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: okCallback,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: okBtnColor),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                '$okText',
                                textAlign: TextAlign.center,
                                style: ThemeText.rodinaTitle3
                                    .copyWith(color: okTxtColor),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  static Future<T> showCustomDialogVerticalMultipleButton<T>(
      BuildContext context, List<Widget> dialogButtons) async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog();
        });
  }

  static Future<T> showCustomDialogWithButton<T>(
      BuildContext context, String title, String message) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '$title',
                  style: ThemeText.sfMediumTitle3,
                ),
                SizedBox(height: 8.0),
                Text('$message',
                    style: ThemeText.sfMediumBody
                        .copyWith(color: ThemeColors.black80)),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  elevation: 1.0,
                  onPressed: () => Navigator.of(context).pop('success'),
                  color: ThemeColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'Yes',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                )
              ],
            ),
          );
        });
  }

  static void closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
