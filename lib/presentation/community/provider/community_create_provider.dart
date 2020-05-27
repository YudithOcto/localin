import 'package:flutter/material.dart';

class CommunityCreateProvider with ChangeNotifier {
  List<String> _selectedLocation = [];
  List<String> get selectedLocation => _selectedLocation;

  set addLocationSelected(String value) {
    _selectedLocation.add(value);
    notifyListeners();
  }

  bool _isContinueButtonActive = false;
  bool get isContinueButtonActive => _isContinueButtonActive;

  final TextEditingController communityName = TextEditingController();
  final TextEditingController communityDescription = TextEditingController();

  @override
  void dispose() {
    communityName.dispose();
    communityDescription.dispose();
    super.dispose();
  }
}
