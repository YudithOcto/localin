import 'package:flutter/material.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';

const DEFAULT_PRICE_HIGHEST = 2000000.0;
const DEFAULT_PRICE_LOWEST = 0.0;

class HotelListFilterProvider with ChangeNotifier {
  HotelListFilterProvider() {
    _selectedFacilities.add(0);
  }

  double _currentHighest = DEFAULT_PRICE_HIGHEST;
  double get currentHighest => _currentHighest;
  set changeHighest(double value) {
    _currentHighest = value;
    notifyListeners();
  }

  double _currentLowest = DEFAULT_PRICE_LOWEST;
  double get currentLowest => _currentLowest;
  set changeLowest(double value) {
    _currentLowest = value;
    notifyListeners();
  }

  List<String> facilities = [
    'All',
    'Parking',
    'Swimming Pool',
    'Kitchen',
    'Refrigerator',
    'Seating Area',
    'Ac',
    'Washroom',
    '24/7 Checkin',
    'Free Wifi',
    'Garden',
    'Tv'
  ];

  List<int> _selectedFacilities = [];
  bool isFacilitySelected(int index) {
    if (_selectedFacilities.contains(index)) {
      return true;
    }
    return false;
  }

  set selectFacility(int index) {
    if (_selectedFacilities.contains(index)) {
      _selectedFacilities.remove(index);
    } else {
      _selectedFacilities.add(index);
    }
    notifyListeners();
  }

  void resetFilter() {
    _selectedFacilities.clear();
    _selectedFacilities.add(0);
    _currentHighest = DEFAULT_PRICE_HIGHEST;
    _currentLowest = DEFAULT_PRICE_LOWEST;
    notifyListeners();
  }

  RevampHotelListRequest get request {
    return RevampHotelListRequest(
      minPrice: _currentLowest,
      maxPrice: _currentHighest,
    );
  }
}
