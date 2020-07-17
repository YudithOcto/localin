import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class BottomButtonPaymentWidget extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onCancelPressed;
  final VoidCallback onPaymentPressed;
  BottomButtonPaymentWidget(
      {@required this.onCancelPressed,
      @required this.onPaymentPressed,
      this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: onCancelPressed,
              child: Container(
                height: 48.0,
                alignment: FractionalOffset.center,
                decoration: BoxDecoration(
                  color: ThemeColors.black60,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(4.0)),
                ),
                child: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.black0),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onPaymentPressed,
              child: Container(
                height: 48.0,
                alignment: FractionalOffset.center,
                decoration: BoxDecoration(
                  color: ThemeColors.primaryBlue,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(4.0)),
                ),
                child: Text(
                  'Pay Now',
                  textAlign: TextAlign.center,
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.black0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
