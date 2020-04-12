import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/themes.dart';

class VerifyCodeProvider with ChangeNotifier {
  Repository _repository = Repository();

  /// UI STATE MANAGEMENT
  bool _isVerifyingCodeNumber = false;
  bool _isRequestingVerifyCode = false;
  Color _color = ThemeColors.black0;
  bool _isEnabled = false;
  String _currentDifference = '';
  bool _isVerifyFormFieldCompleted = false;
  final List<TextEditingController> _editingController =
      List<TextEditingController>();
  final _nodes = List<FocusNode>();
  TimerState _timerState = TimerState.Default;
  Timer _timer;
  int _seconds = 120;

  /// TIMER
  VerifyCodeProvider() {
    createFormTextField();
    _startTimer();
  }

  createFormTextField() {
    for (int i = 0; i < 4; i++) {
      _nodes.add(FocusNode());
      _editingController.add(TextEditingController(text: ""));
    }
  }

  void setCodeInputStatusCompleted() {
    _isVerifyFormFieldCompleted = !_isVerifyFormFieldCompleted;
    notifyListeners();
  }

  void clearTextFormField() {
    _editingController.forEach((value) => value.clear());
    setCodeInputStatusCompleted();
  }

  verifyingCodeStateChanges() {
    _isVerifyingCodeNumber = !_isVerifyingCodeNumber;
    _isEnabled = !_isEnabled;
    _color = !_isEnabled ? ThemeColors.black0 : ThemeColors.black10;
    if (_timer == null) {
      _startTimer();
    }
  }

  /// API RELATED
  Future<UserBaseModel> verifySmsCode() async {
    verifyingCodeStateChanges();
    String verifyCode = '';
    _editingController.forEach((value) => verifyCode += value.text);

    final response =
        await _repository.verifyPhoneVerificationCode(int.parse(verifyCode));
    return response;
  }

  Future<UserBaseModel> requestingVerifyCodeBySms(String phoneNumber) async {
    _startTimer();
    _isRequestingVerifyCode = !_isRequestingVerifyCode;
    if (!phoneNumber.startsWith('0')) {
      phoneNumber = '0$phoneNumber';
    }
    final response = await _repository.userPhoneRequestCode(phoneNumber);
    if (response != null) {
      _isRequestingVerifyCode = !_isRequestingVerifyCode;
    }
    return response;
  }

  @override
  void dispose() {
    _editingController.forEach((value) => value.dispose());
    _nodes.forEach((value) => value.dispose());
    _cancelTimer();
    super.dispose();
  }

  void _startTimer() {
    DateTime startDateTime = DateTime.now().add(Duration(seconds: 120));
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime timeNow = DateTime.now();
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = 120;
        _timerState = TimerState.Expired;
        _timer = null;
        notifyListeners();
        return;
      }

      _currentDifference =
          '${startDateTime.difference(timeNow).inMinutes.toString().padLeft(2, '0')}:${(startDateTime.difference(timeNow).inSeconds % 60).toString().padLeft(2, '0')}';
      _seconds--;
      _timerState = TimerState.Progress;
      notifyListeners();
    });
  }

  _cancelTimer() {
    if (_timer != null && _timer.isActive) {
      _timer?.cancel();
    }
  }

  String get currentDifference => _currentDifference;
  bool get isVerifyCodeNumber => _isVerifyingCodeNumber;
  bool get isRequestingVerifyCode => _isRequestingVerifyCode;
  bool get isFormEnabled => _isEnabled;
  Color get formColor => _color;
  List<TextEditingController> get formController => _editingController;
  List<FocusNode> get nodeController => _nodes;
  int get seconds => _seconds;
  TimerState get timerState => _timerState;
  bool get isFormFieldsCompleted => _isVerifyFormFieldCompleted;
}

enum TimerState { Default, Progress, Expired }
