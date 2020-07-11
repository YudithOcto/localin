import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/explore_filter_response_model.dart';

class ExploreFilterProvider with ChangeNotifier {
  List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  int _selectedMonth;
  int get selectedMonth => _selectedMonth;
  set selectMonth(int index) {
    _selectedMonth = index;
    notifyListeners();
  }

  List<String> sortList = [
    'Closest date',
    'Furthest Date',
    'Lowest Price',
    'Expensive Price'
  ];
  int _selectedSort;
  int get selectedSort => _selectedSort;
  set selectSort(int index) {
    _selectedSort = index;
    notifyListeners();
  }

  resetFilter() {
    _selectedCategory.clear();
    _selectedSort = null;
    _selectedMonth = null;
    notifyListeners();
  }

  final _streamController = StreamController<filterState>.broadcast();
  Stream<filterState> get stream => _streamController.stream;

  final _repository = Repository();
  List<CategoryExploreDetail> _selectedCategory = [];
  List<CategoryExploreDetail> get selectedCategory => _selectedCategory;

  List<CategoryExploreDetail> _listCategory = [];
  List<CategoryExploreDetail> get listCategory => _listCategory;
  set selectCategory(CategoryExploreDetail value) {
    if (_selectedCategory.contains(value)) {
      _selectedCategory.remove(value);
    } else {
      _selectedCategory.add(value);
    }
    notifyListeners();
  }

  Future<Null> getFilterCategory() async {
    final result = await _repository.getCategoryFilterEvent();
    _streamController.add(filterState.loading);
    if (result != null && result.total > 0) {
      _listCategory.addAll(result.detail);
      _streamController.add(filterState.success);
    } else {
      _streamController.add(filterState.empty);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

enum filterState { loading, success, empty }
