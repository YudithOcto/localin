import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_category.dart';

class CommunityCreateProvider with ChangeNotifier {
  final _repository = Repository();

  List<String> _selectedLocation = [];
  List<String> get selectedLocation => _selectedLocation;

  set addLocationSelected(String value) {
    _selectedLocation.add(value);
    notifyListeners();
  }

  List<int> _selectedCategory = List();
  List<int> get selectedCategory => _selectedCategory;
  bool isCategorySelected(int value) {
    if (_selectedCategory.contains(value)) {
      return true;
    }
    return false;
  }

  void selectCategory(int value) {
    if (_selectedCategory.contains(value)) {
      _selectedCategory.remove(value);
    } else {
      _selectedCategory.add(value);
    }
    notifyListeners();
  }

  bool _isContinueButtonActive = false;
  bool get isContinueButtonActive => _isContinueButtonActive;

  final TextEditingController communityName = TextEditingController();
  final TextEditingController communityDescription = TextEditingController();

  Future<List<CommunityCategory>> getCategoryList() async {
    final response = await _repository.getCategoryListCommunity('');
    if (response.error == null) {
      return response.communityCategory;
    }
    return List();
  }

  @override
  void dispose() {
    communityName.dispose();
    communityDescription.dispose();
    super.dispose();
  }
}
