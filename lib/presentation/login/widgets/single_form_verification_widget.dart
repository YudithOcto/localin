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
          return Material(
            color: provider.formColor,
            shape: SuperellipseShape(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: ThemeColors.black10)),
            child: Center(
              child: TextFormField(
                autofocus: true,
                enabled: !provider.isFormDisabled,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                ],
                maxLines: 1,
                keyboardType: TextInputType.number,
                onChanged: (value) {},
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    border: InputBorder.none),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on TimerState {
  bool get isOnProgress {
    return this == TimerState.Progress;
  }

  bool get isExpired {
    return this == TimerState.Expired;
  }

  bool get isNotStart {
    return this == TimerState.Default;
  }

  bool get defaultOrOnProgress {
    return this == TimerState.Default || this == TimerState.Progress;
  }

  bool get defaultOrExpired {
    return this == TimerState.Default || this == TimerState.Expired;
  }
}
