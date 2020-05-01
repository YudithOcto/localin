import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/themes.dart';
import 'package:oktoast/oktoast.dart' as okToast;

import '../text_themes.dart';

class CustomToast {
  static showCustomToast(BuildContext context, String message,
      {AlignmentGeometry alignment = Alignment.bottomCenter}) {
    showToast('$message',
        context: context,
        position: StyledToastPosition(offset: 70.0, align: alignment),
        textStyle:
            ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.red80),
        backgroundColor: ThemeColors.red10);
  }

  static showCustomBookmarkToast(BuildContext context, String message,
      {AlignmentGeometry alignment = Alignment.bottomCenter,
      VoidCallback callback}) {
    okToast.showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Material(
          shadowColor: ThemeColors.black80,
          elevation: 1,
          color: ThemeColors.black0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Container(
            height: 60.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset(
                      'images/bookmark_full.svg',
                      width: 15.46,
                      height: 16.93,
                      color: ThemeColors.primaryBlue,
                    ),
                    SizedBox(
                      width: 11.0,
                    ),
                    Text(
                      'Added to bookmark',
                      style: ThemeText.sfSemiBoldBody,
                    ),
                  ],
                ),
                InkWell(
                  onTap: callback,
                  child: Text(
                    'Undo',
                    style: ThemeText.sfSemiBoldBody
                        .copyWith(color: ThemeColors.primaryBlue),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      animationBuilder: okToast.Miui10AnimBuilder(),
      animationDuration: Duration(milliseconds: 100),
      textDirection: TextDirection.ltr,
      duration: Duration(seconds: 5),
      animationCurve: Curves.easeIn,
      context: context,
      position:
          okToast.ToastPosition(offset: -90, align: Alignment.bottomCenter),
      handleTouch: true,
      dismissOtherToast: true,
    );
  }
}
