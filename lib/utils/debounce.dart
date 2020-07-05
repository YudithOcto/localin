import 'dart:async';

import 'package:dio/dio.dart';

class Debounce {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debounce({this.milliseconds});

  cancel() {
    if (_timer?.isActive ?? false) {
      _timer.cancel();
    }
  }

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
