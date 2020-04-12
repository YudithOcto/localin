import 'package:flutter/material.dart';
import 'package:localin/presentation/login/widgets/single_form_verification_widget.dart';

class ListFormVerificationWidget extends StatefulWidget {
  const ListFormVerificationWidget({
    Key key,
  }) : super(key: key);

  @override
  _ListFormVerificationWidgetState createState() =>
      _ListFormVerificationWidgetState();
}

class _ListFormVerificationWidgetState
    extends State<ListFormVerificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: List.generate(4, (index) {
        return SingleFormVerificationWidget(
          index: index,
        );
      }),
    );
  }
}
