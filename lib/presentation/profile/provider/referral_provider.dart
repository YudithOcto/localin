import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';

class ReferralProvider with ChangeNotifier {
  final _repository = Repository();

  final referralEditTextController = TextEditingController();

  inputReferral() async {
    final response =
        await _repository.inputFriendsReferral(referralEditTextController.text);
    return response;
  }

  bool get isTextNotEmpty => referralEditTextController.text.isNotEmpty;
}
