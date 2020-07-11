import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:localin/api/repository.dart';

const TYPE_LOCATION = 'location';
const TYPE_EVENT = 'event';

class GenericProvider with ChangeNotifier {
  final Repository _repository = Repository();
  final searchController = TextEditingController();

  int _offset = 1;
  int get offset => _offset;

  int _limit = 10;
  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  final StreamController<searchState> _streamController =
      StreamController<searchState>.broadcast();
  Stream<searchState> get searchStream => _streamController.stream;

  List<dynamic> _searchList = [];
  List<dynamic> get searchList => _searchList;

  Future<Null> loadSearchData(
      {String search, bool isRefresh = true, @required String type}) async {
    if (isRefresh) {
      _offset = 1;
      _searchList.clear();
      _canLoadMore = true;
    }
    if (!_canLoadMore) {
      return;
    }
    _streamController.add(searchState.loading);
    final result = await loadDataBaseOnType(type: type, search: search);
    if (result != null && result.total > 0) {
      _searchList.addAll(result.detail);
      _offset += 1;
      _canLoadMore = result.total > _searchList.length;
      _streamController.add(searchState.success);
    } else {
      _canLoadMore = false;
      _streamController.add(searchState.empty);
    }
    notifyListeners();
  }

  loadDataBaseOnType({@required String type, String search}) {
    switch (type) {
      case TYPE_LOCATION:
        return _repository.searchLocation(
            offset: _offset, limit: _limit, search: search);
        break;
      case TYPE_EVENT:
        return _repository.getEventList(pageRequest: _offset, search: search);
        break;
    }
  }

  @override
  void dispose() {
    _streamController.close();
    searchController.dispose();
    super.dispose();
  }
}

enum searchState { loading, success, empty }
