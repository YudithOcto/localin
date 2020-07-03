import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/countdown.dart';

class TopBarTransactionStatusWidget extends StatefulWidget {
  final Color backgroundColor;
  final String status;
  final String expiredAt;
  TopBarTransactionStatusWidget(
      {Key key,
      @required this.backgroundColor,
      @required this.status,
      this.expiredAt})
      : super(key: key);

  @override
  _TopBarTransactionStatusWidgetState createState() =>
      _TopBarTransactionStatusWidgetState();
}

class _TopBarTransactionStatusWidgetState
    extends State<TopBarTransactionStatusWidget> {
  Countdown _countdown;

  startCountDown(DateTime expiredTime) {
    _countdown = Countdown(expiredTime: expiredTime);
    _countdown.run();
  }

  @override
  void initState() {
    if (widget.status.contains('Waiting for payment')) {
      startCountDown(DateTime.parse(widget.expiredAt));
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_countdown != null) {
      _countdown.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      width: double.maxFinite,
      height: 36.0,
      color: widget.status.rowColor,
      child: widget.status.contains('Waiting for payment')
          ? StreamBuilder<String>(
              stream: _countdown.differenceStream,
              builder: (context, snapshot) {
                return Text(
                  '${widget.status} \u2022 ${snapshot.data ?? '00:00'}',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black0),
                );
              })
          : Text(
              '${widget.status}',
              textAlign: TextAlign.center,
              style: ThemeText.sfMediumFootnote
                  .copyWith(color: ThemeColors.black0),
            ),
    );
  }
}

extension on String {
  Color get rowColor {
    if (this.contains('Waiting for payment')) {
      return ThemeColors.orange;
    } else if (this.contains('Canceled')) {
      return ThemeColors.red;
    } else if (this.contains('Finished')) {
      return ThemeColors.green;
    } else {
      return ThemeColors.primaryBlue;
    }
  }
}
