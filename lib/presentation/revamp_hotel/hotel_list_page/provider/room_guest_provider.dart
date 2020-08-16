import 'package:flutter/material.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/main.dart';

class RoomGuestProvider with ChangeNotifier {
  RoomGuestProvider(
      {int totalRoomSelected, int totalAdultSelected, int totalChildSelected}) {
    _roomSelected = totalRoomSelected;
    _adultSelected = totalAdultSelected;
    _childSelected = totalChildSelected;
  }

  int _roomSelected = 1;
  int get roomSelected => _roomSelected;
  set changeRoomValue(bool isAdding) {
    if (isAdding) {
      int currentRoomForChecking = _roomSelected + 1;
      if (currentRoomForChecking > _adultSelected) {
        CustomToast.showCustomBookmarkToast(navigator.currentContext,
            'Number of Rooms Can\'t Be More Than Adults');
        return;
      }
      _roomSelected++;
    } else {
      if (_roomSelected <= 1) {
        return;
      } else {
        int _tempCheck = _roomSelected - 1;
        if (_tempCheck * 2 < _adultSelected) {
          CustomToast.showCustomBookmarkToast(navigator.currentContext,
              'You have reached maximum number adults per room');
          return;
        }
        _roomSelected -= 1;
      }
    }
    notifyListeners();
  }

  int _adultSelected = 1;
  int get adultSelected => _adultSelected;
  set changeAdultValue(bool isAdding) {
    if (isAdding) {
      int _tempAdults = _adultSelected + 1;
      if (_tempAdults <= _roomSelected * 2) {
        _adultSelected += 1;
      } else {
        CustomToast.showCustomBookmarkToast(navigator.currentContext,
            'You have reached maximum number adults per room');
        return;
      }
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
      int _tempCheck = _childSelected + 1;
      if (_tempCheck < _adultSelected) {
        _childSelected += 1;
        CustomToast.showCustomBookmarkToast(navigator.currentContext,
            'Number of child Can\'t Be More Than Adults');
      }
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
