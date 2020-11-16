import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
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
  String transactionStatus = '';

  startCountDown(DateTime expiredTime) {
    _countdown = Countdown(expiredTime: expiredTime);
    _countdown.run();
  }

  @override
  void initState() {
    transactionStatus = widget.status;
    if (transactionStatus.contains(kTransactionWaitingPayment)) {
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
    return transactionStatus.contains(kTransactionWaitingPayment)
        ? StreamBuilder<String>(
            stream: _countdown.differenceStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                if (!_countdown.isTimerActive()) {
                  Future.delayed(Duration.zero, () {
                    setState(() {
                      transactionStatus = kTransactionCancelled;
                    });
                  });
                } else {
                  return Container();
                }
              }

              return Container(
                alignment: FractionalOffset.center,
                width: double.maxFinite,
                height: 36.0,
                color: snapshot.data == null
                    ? kTransactionCancelled.rowColor
                    : transactionStatus.rowColor,
                child: Text(
                  '${snapshot.data == null ? kTransactionCancelled : '$transactionStatus \u2022'} ${snapshot.data ?? ''}',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black0),
                ),
              );
            })
        : Container(
            alignment: FractionalOffset.center,
            width: double.maxFinite,
            height: 36.0,
            color: transactionStatus.rowColor,
            child: Text(
              '$transactionStatus',
              textAlign: TextAlign.center,
              style: ThemeText.sfMediumFootnote
                  .copyWith(color: ThemeColors.black0),
            ),
          );
  }
}

extension on String {
  Color get rowColor {
    if (this.toLowerCase().contains('Waiting for payment'.toLowerCase())) {
      return ThemeColors.orange;
    } else if (this.toLowerCase().contains('Canceled'.toLowerCase())) {
      return ThemeColors.red;
    } else if (this.toLowerCase().contains('Finished'.toLowerCase())) {
      return ThemeColors.green;
    } else {
      return ThemeColors.primaryBlue;
    }
  }
}
