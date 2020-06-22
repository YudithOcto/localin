import 'package:flutter/material.dart';

class TopBarTransactionStatusWidget extends StatelessWidget {
  final Color backgroundColor;
  final Widget childWidget;
  TopBarTransactionStatusWidget(
      {Key key, @required this.backgroundColor, this.childWidget})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      width: double.maxFinite,
      height: 36.0,
      color: backgroundColor,
      child: childWidget,
    );
  }
}
