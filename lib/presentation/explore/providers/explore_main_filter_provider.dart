import 'package:flutter/foundation.dart';
import 'package:localin/model/explore/explore_filter_model_request.dart';
import 'package:localin/model/explore/explore_filter_response_model.dart';
import 'package:localin/presentation/explore/utils/filter.dart';

class ExploreMainFilterProvider with ChangeNotifier {
  ExploreMainFilterProvider() {
    defaultFilter();
  }

  defaultFilter() {
    _selectedFilter.add('All');
    _selectedFilter.add('In the next 2 months');
    _selectedFilter.add('Asc');
  }

  addFilter(ExploreFilterModelRequest modelRequest) {
    try {
      if (modelRequest.category.isEmpty &&
          modelRequest.month == null &&
          modelRequest.sort == null) {
        _selectedFilter.clear();
        _selectedCategoryFilter.clear();
        defaultFilter();
        notifyListeners();
      } else {
        if (modelRequest != null) {
          if (modelRequest.month != null) {
            _selectedFilter.replaceRange(1, 2, [monthList[modelRequest.month]]);
          }

          if (modelRequest.sort != null) {
            _selectedFilter.replaceRange(2, 3, [sortList[modelRequest.sort]]);
          }

          if (modelRequest.category != null) {
            _selectedFilter.replaceRange(
                0, 1, [modelRequest.category.map((e) => e.category).join(',')]);
            _selectedCategoryFilter.clear();
            _selectedCategoryFilter.addAll(modelRequest.category);
          }
        }
      }
    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  List<CategoryExploreDetail> _selectedCategoryFilter = [];
  List<CategoryExploreDetail> get selectedCategoryFilter =>
      _selectedCategoryFilter;

  get eventRequestModel {
    return ExploreFilterModelRequest(
      month: monthList.indexOf(_selectedFilter[1]),
      sort: sortList.indexOf(_selectedFilter[2]),
      category: _selectedCategoryFilter,
    );
  }

  List<String> _selectedFilter = [];
  List<String> get selectedFilter => _selectedFilter;
}
