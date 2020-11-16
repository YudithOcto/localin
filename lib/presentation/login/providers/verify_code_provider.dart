import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/themes.dart';

class VerifyCodeProvider with ChangeNotifier {
  Repository _repository = Repository();

  /// UI STATE MANAGEMENT
  bool _isVerifyingCodeNumber = false;
  bool _isRequestingNewSmsCode = false;
  String errorMessage = '';
  Color _color = ThemeColors.black0;
  bool _isFormDisabled = false;
  bool _isAllFieldsFilled = false;
  final StreamController<bool> _textClear = StreamController<bool>.broadcast();
  String _currentFilledVerifyCode = '';

  /// TIMER
  TimerState _timerState = TimerState.Default;
  Timer _timer;
  String _currentDifference = '';

  VerifyCodeProvider() {
    _startTimer();
  }

  void enabledForm() {
    _isFormDisabled = false;
    _color = ThemeColors.black0;
    notifyListeners();
  }

  void disabledForm() {
    _isFormDisabled = true;
    _color = ThemeColors.black10;
    notifyListeners();
  }

  verifyingCodeStateChanges({bool isNeedToDisableForm = false}) {
    _isVerifyingCodeNumber = !_isVerifyingCodeNumber;
    _color = _isVerifyingCodeNumber ? ThemeColors.black10 : ThemeColors.black0;
    notifyListeners();
  }

  void setAllFieldsFilled(bool isValueCompleted) {
    _isAllFieldsFilled = isValueCompleted;
    notifyListeners();
  }

  void setFieldVerifyCode(String value) {
    _currentFilledVerifyCode = value;
    notifyListeners();
  }

  void clearTextFormField() {
    _textClear.add(true);
  }

  /// API RELATED
  Future<UserBaseModel> verifySmsCode() async {
    verifyingCodeStateChanges();
    final response = await _repository
        .verifyPhoneVerificationCode(int.parse(_currentFilledVerifyCode));
    if (response.error != null && !response.error.contains('ganti') ||
        response.error == null) {
      clearTextFormField();
    }
    verifyingCodeStateChanges();
    return response;
  }

  Future<UserBaseModel> requestingCodeBySms(String phoneNumber) async {
    _startTimer();
    _requestingNewSmsCodeCircular();
    if (phoneNumber.startsWith('+62')) {
      phoneNumber = '0${phoneNumber.substring(3, phoneNumber.length)}';
    }
    final response = await _repository.userPhoneRequestCode(phoneNumber);
    _requestingNewSmsCodeCircular();
    return response;
  }

  void _requestingNewSmsCodeCircular() {
    _isRequestingNewSmsCode = !_isRequestingNewSmsCode;
  }

  @override
  void dispose() {
    _textClear.close();
    _cancelTimer();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null && _timer.isActive) {
      return;
    }
    DateTime startDateTime = DateTime.now().add(Duration(seconds: 120));
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime timeNow = DateTime.now();
      if (timer.tick == 120) {
        _cancelTimer();
        _timerState = TimerState.Expired;
        clearTextFormField();
        disabledForm();
        notifyListeners();
        return;
      }

      _currentDifference =
          '${startDateTime.difference(timeNow).inMinutes.toString().padLeft(2, '0')}:${(startDateTime.difference(timeNow).inSeconds % 60).toString().padLeft(2, '0')}';
      _timerState = TimerState.Progress;
      notifyListeners();
    });
  }

  _cancelTimer() {
    if (_timer != null && _timer.isActive) {
      _timer?.cancel();
      _timer = null;
    }
  }

  String get currentDifference => _currentDifference;

  bool get isVerifyCodeNumber => _isVerifyingCodeNumber;

  bool get requestingNewSmSCode => _isRequestingNewSmsCode;

  Color get formColor => _color;

  TimerState get timerState => _timerState;

  bool get isFormDisabled => _isFormDisabled;

  bool get isAllFieldsFilled => _isAllFieldsFilled;

  Stream<bool> get clearAllField => _textClear.stream;
}

enum TimerState { Default, Progress, Expired }
