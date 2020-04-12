import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localin/presentation/login/providers/verify_code_provider.dart';
import 'package:provider/provider.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import '../../../themes.dart';

class SingleFormVerificationWidget extends StatefulWidget {
  final int index;
  const SingleFormVerificationWidget({
    Key key,
    this.index,
  }) : super(key: key);
  @override
  _SingleFormVerificationWidgetState createState() =>
      _SingleFormVerificationWidgetState();
}

class _SingleFormVerificationWidgetState
    extends State<SingleFormVerificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: Consumer<VerifyCodeProvider>(
        builder: (context, provider, child) {
          return IgnorePointer(
            ignoring: provider.isVerifyCodeNumber,
            child: Material(
              color: provider.formColor,
              shape: SuperellipseShape(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: ThemeColors.black10)),
              child: Center(
                child: TextField(
                  autofocus: true,
                  showCursor: !provider.isVerifyCodeNumber,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                  ],
                  maxLines: 1,
                  onSubmitted: (value) => FocusScope.of(context)
                      .requestFocus(provider.nodeController[widget.index]),
                  keyboardType: TextInputType.number,
                  controller: provider.formController[widget.index],
                  textAlign: TextAlign.center,
                  focusNode: provider.nodeController[widget.index],
                  onChanged: (value) {
                    if (widget.index < provider.nodeController.length - 1 &&
                        provider.formController[widget.index].text.isNotEmpty) {
                      FocusScope.of(context).requestFocus(
                          provider.nodeController[widget.index + 1]);
                      provider.formController[widget.index + 1].selection =
                          TextSelection.collapsed(offset: 0);
                    } else {
                      provider.setCodeInputStatusCompleted();
                    }
                  },
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                      border: InputBorder.none),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
