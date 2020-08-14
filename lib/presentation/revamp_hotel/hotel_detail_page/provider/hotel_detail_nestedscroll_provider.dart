import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../main.dart';

class HotelDetailNestedScrollProvider with ChangeNotifier {
  List<String> tabList = ['Overview', 'Facilities', 'Location', 'Details'];

  int _activeIndex = 0;
  int get activeIndex => _activeIndex;
  set indexActive(int index) {
    _activeIndex = index;
    notifyListeners();
  }

  AutoScrollController controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(
          0, 0, 0, MediaQuery.of(navigator.currentContext).padding.bottom));

  final _itemPositionedListener = ItemPositionsListener.create();
  ItemPositionsListener get itemPositionedListener => _itemPositionedListener;
}
