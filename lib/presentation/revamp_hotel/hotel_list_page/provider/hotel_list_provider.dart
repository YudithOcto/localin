import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HotelListProvider with ChangeNotifier {
  bool get showSearchAppBar => _showSearchAppBar;
  bool _showSearchAppBar = false;
  set searchAppBar(bool value) {
    _showSearchAppBar = value;
  }

  final _scrollController = ItemScrollController();
  ItemScrollController get scrollController => _scrollController;

  final _itemPositionedListener = ItemPositionsListener.create();
  ItemPositionsListener get itemPositionedListener => _itemPositionedListener;

  final panelController = PanelController();
}
