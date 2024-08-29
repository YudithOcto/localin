import 'package:flutter/cupertino.dart';
import 'package:localin/api/repository.dart';

class ReferralProvider with ChangeNotifier {
  final _repository = Repository();
  final referralEditTextController = TextEditingController();

  ReferralProvider({String ref = ''}) {
    referralEditTextController.text = ref;
  }

  inputReferral() async {
    final response =
        await _repository.inputFriendsReferral(referralEditTextController.text);
    _statusSuccess = response.error;
    notifyListeners();
    return response;
  }

  bool _statusSuccess = false;

  bool get statusSuccess => _statusSuccess;

  bool get isTextNotEmpty => referralEditTextController.text.isNotEmpty;
}
