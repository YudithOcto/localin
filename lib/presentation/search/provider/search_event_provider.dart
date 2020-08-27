import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:localin/api/explore_last_search_dao.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/explore/base_event_request_model.dart';
import 'package:localin/model/explore/explore_default_search_response.dart';
import 'package:localin/model/explore/explore_event_local_model.dart';
import 'package:localin/model/explore/explore_event_response_model.dart';
import 'package:localin/model/explore/explore_suggest_nearby.dart';
import 'package:localin/model/explore/explore_title.dart';

const TYPE_LOCATION = 'location';
const TYPE_EVENT = 'event';

class SearchEventProvider with ChangeNotifier {
  final Repository _repository = Repository();
  final searchController = TextEditingController();

  int _offset = 1;
  int get offset => _offset;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  final StreamController<searchState> _streamController =
      StreamController<searchState>.broadcast();
  Stream<searchState> get searchStream => _streamController.stream;

  List<BaseEventRequestmodel> _searchList = [];
  List<BaseEventRequestmodel> get searchList => _searchList;

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
    if (searchController.text.isEmpty) {
      addDefaultResult();
    } else {
      final result = await _repository.getEventList(
          pageRequest: _offset, search: search, mode: 'search');
      if (result != null && result.total > 0) {
        addSearchResult(result);
      } else {
        _canLoadMore = false;
        _streamController.add(searchState.empty);
      }
    }
  }

  addDefaultResult() async {
    final result = await getLastSearchFromLocal();
    final defaultSearch = await getDefaultSearch();
    _searchList.add(ExploreSuggestNearby(title: 'Event & Attraction Near You'));
    if (result.isNotNullNorEmpty) {
      _searchList.add(ExploreTitle(title: 'Your Last Search'));
      _searchList.addAll(result);
    }
    if (defaultSearch != null) {
      if (defaultSearch.location.isNotNullNorEmpty) {
        _searchList.add(ExploreTitle(title: 'Location'));
        _searchList.addAll(defaultSearch.location);
      }
      if (defaultSearch.category.isNotNullNorEmpty) {
        _searchList.add(ExploreTitle(title: 'Category'));
        defaultSearch.category.forEach((element) {
          if (element.categoryName != '-') {
            _searchList.add(element);
          }
        });
      }
    }
    _canLoadMore = false;
    _streamController.add(searchState.success);
    notifyListeners();
  }

  List<ExploreEventDetail> _trackEventListDetail = [];
  addSearchResult(ExploreEventResponseModel result) {
    _trackEventListDetail.addAll(result.detail);
    if (result.listSearchLocation.isNotNullNorEmpty) {
      _searchList.add(ExploreTitle(title: 'Location'));
      _searchList.addAll(result.listSearchLocation);
    }
    if (result.detail.isNotNullNorEmpty) {
      _searchList.add(ExploreTitle(title: 'Event'));
      _searchList.addAll(result.detail);
    }
    _offset += 1;
    _canLoadMore = result.total > _trackEventListDetail.length;
    _streamController.add(searchState.success);
    notifyListeners();
  }

  Future<ExploreDefaultSearchResponse> getDefaultSearch() async {
    return await _repository.getEventDefaultSearch();
  }

  @override
  void dispose() {
    _streamController.close();
    searchController.dispose();
    super.dispose();
  }

  final ExploreLastSearchDao _exploreLastSearchDao = ExploreLastSearchDao();

  Future<int> addToSearchLocal(ExploreEventLocalModel exploreLocalModel) async {
    final result = await _exploreLastSearchDao.insert(exploreLocalModel);
    return result;
  }

  Future<List<ExploreEventLocalModel>> getLastSearchFromLocal() async {
    final result = await _exploreLastSearchDao.getAllExploreList();
    return result;
  }
}

enum searchState { loading, success, empty }

extension on List {
  bool get isNotNullNorEmpty {
    return this != null && this.isNotEmpty;
  }
}
