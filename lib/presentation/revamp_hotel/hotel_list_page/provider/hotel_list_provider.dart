import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HotelListProvider with ChangeNotifier {
  bool get showSearchAppBar => _showSearchAppBar;
  bool _showSearchAppBar = false;
  set searchAppBar(bool value) {
    _showSearchAppBar = value;
  }

  final _scrollController = ScrollController();
  get scrollController => _scrollController;

  HotelListProvider() {
    _scrollController..addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.03 &&
        !_showSearchAppBar) {
      _showSearchAppBar = true;
    } else if (_scrollController.offset <
            _scrollController.position.maxScrollExtent * 0.03 &&
        _showSearchAppBar) {
      _showSearchAppBar = false;
    }
//    else if (_scrollController.offset >=
//        _scrollController.position.maxScrollExtent &&
//        _canLoadMore) {
//      getRestaurantList(isRefresh: false);
//    }
    notifyListeners();
  }
}
