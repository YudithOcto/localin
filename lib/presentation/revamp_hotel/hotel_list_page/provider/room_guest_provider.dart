import 'package:flutter/material.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/main.dart';

class RoomGuestProvider with ChangeNotifier {
  RoomGuestProvider({int totalRoomSelected}) {
    print(totalRoomSelected);

    _roomSelected = totalRoomSelected;
  }

  int _roomSelected = 1;
  int get roomSelected => _roomSelected;
  set changeRoomValue(bool isAdding) {
    if (isAdding) {
//      int currentRoomForChecking = _roomSelected + 1;
//      if (currentRoomForChecking > _adultSelected) {
//        CustomToast.showCustomBookmarkToast(navigator.currentContext,
//            'Number of Rooms Can\'t Be More Than Adults');
//        return;
//      }
      _roomSelected++;
    } else {
      if (_roomSelected <= 1) {
        return;
      } else {
        _roomSelected -= 1;
      }
    }
    notifyListeners();
  }

  int _adultSelected = 1;
  int get adultSelected => _adultSelected;
  set changeAdultValue(bool isAdding) {
    if (isAdding) {
      _adultSelected += 1;
    } else {
      if (_adultSelected <= 1) {
        return;
      } else {
        int currentAdultsForChecking = _adultSelected - 1;
        if (_roomSelected > currentAdultsForChecking) {
          CustomToast.showCustomBookmarkToast(navigator.currentContext,
              'Number of Rooms Can\'t Be More Than Adults');
          return;
        }
        _adultSelected -= 1;
      }
    }
    notifyListeners();
  }

  int _childSelected = 0;
  int get childSelected => _childSelected;
  set changeChildValue(bool isAdding) {
    if (isAdding) {
      _childSelected += 1;
    } else {
      if (_childSelected <= 0) {
        return;
      } else {
        _childSelected -= 1;
      }
    }
    notifyListeners();
  }
}
