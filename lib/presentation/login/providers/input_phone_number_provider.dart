import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';

class InputPhoneNumberProvider with ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _phoneNumberController = TextEditingController();
  Repository _repository = Repository();
  bool _isLoading = false;

  bool get autoValidateForm => _autoValidate;
  TextEditingController get phoneNumberController => _phoneNumberController;
  bool get isLoading => _isLoading;

  Future<String> userPhoneRequest() async {
    String _userRealPhoneNumber = '';
    if (!_phoneNumberController.text.startsWith('0')) {
      _userRealPhoneNumber = '0${_phoneNumberController.text}';
    } else {
      _userRealPhoneNumber = _phoneNumberController.text;
    }
    final response =
        await _repository.userPhoneRequestCode(_userRealPhoneNumber);
    if (response != null && response.error == null) {
      return '';
    } else {
      return response.error;
    }
  }

  void setLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setAutoValidate() {
    _autoValidate = !_autoValidate;
    notifyListeners();
  }

  Future<bool> validateInput() async {
    setLoading();
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      setLoading();
      setAutoValidate();
      return false;
    }
  }
}
