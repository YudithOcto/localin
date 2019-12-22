import 'package:flutter/material.dart';

class BaseModelProvider extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}

enum ViewState { Idle, Busy }
