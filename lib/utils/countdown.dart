import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Countdown {
  Timer _timer;
  final DateTime expiredTime;
  VoidCallback action;
  StreamController<String> _counterStream =
      StreamController<String>.broadcast();

  Stream<String> get differenceStream => _counterStream.stream;

  Function(String) get _addDifferences => _counterStream.sink.add;

  Countdown({@required this.expiredTime});

  cancel() {
    if (_timer?.isActive ?? false) {
      _timer.cancel();
    }
    _counterStream.close();
  }

  isTimerActive() {
    return _timer?.isActive ?? false;
  }

  run() {
    if (_timer?.isActive ?? false) {
      _timer.cancel();
      _counterStream.close();
    }
    if (expiredTime.isBefore(DateTime.now())) {
      return;
    }
    if (_counterStream == null || _counterStream.isClosed) {
      _counterStream = StreamController<String>.broadcast();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      if (expiredTime.difference(now).inSeconds >= 0) {
        _addDifferences(
            '${expiredTime.difference(now).inMinutes.toString().padLeft(2, '0')}'
            ':${(expiredTime.difference(now).inSeconds % 60).toString().padLeft(2, '0')}');
      } else {
        cancel();
      }
    });
  }
}
