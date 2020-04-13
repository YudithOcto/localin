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
  final List<TextEditingController> _editingController =
      List<TextEditingController>();
  final _nodes = List<FocusNode>();

  /// TIMER
  TimerState _timerState = TimerState.Default;
  Timer _timer;
  String _currentDifference = '';

  VerifyCodeProvider() {
    initTextFormField();
    _startTimer();
  }

  initTextFormField() {
    for (int i = 0; i < 4; i++) {
      _nodes.add(FocusNode());
      _editingController.add(TextEditingController(text: ""));
    }
  }

  void clearTextFormField() {
    _editingController.forEach((value) => value.clear());
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

  void setAllFieldsFilled() {
    _isAllFieldsFilled = !_isAllFieldsFilled;
    notifyListeners();
  }

  /// API RELATED
  Future<UserBaseModel> verifySmsCode() async {
    verifyingCodeStateChanges();
    String verifyCode = '';
    _editingController.forEach((value) => verifyCode += value.text);

    final response =
        await _repository.verifyPhoneVerificationCode(int.parse(verifyCode));
    clearTextFormField();
    verifyingCodeStateChanges();
    return response;
  }

  Future<UserBaseModel> requestingCodeBySms(String phoneNumber) async {
    _startTimer();
    _requestingNewSmsCodeCircular();
    if (!phoneNumber.startsWith('0')) {
      phoneNumber = '0$phoneNumber';
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
    _editingController.forEach((value) => value.dispose());
    _nodes.forEach((value) => value.dispose());
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
        _editingController.forEach((value) => value.clear());
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
  List<TextEditingController> get formController => _editingController;
  List<FocusNode> get nodeController => _nodes;
  TimerState get timerState => _timerState;
  bool get isFormDisabled => _isFormDisabled;
  bool get isAllFieldsFilled => _isAllFieldsFilled;
}

enum TimerState { Default, Progress, Expired }
