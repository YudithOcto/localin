import 'package:flutter/material.dart';

class TransactionHeaderProvider with ChangeNotifier {
  int _headerCurrentSelected = 0;
  int get currentHeaderSelected => _headerCurrentSelected;

  set selectedHeader(int index) {
    _headerCurrentSelected = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  List<String> _newsTab = ['Stay', 'Community', 'explore'];
  List<String> get newsTabTitle => _newsTab;

  List<String> _iconsTab = [
    'images/transaction_stay_tab_icon.svg',
    'images/transaction_community_tab_icon.svg',
    'images/transaction_explore_tab.svg',
  ];
  List<String> get iconTab => _iconsTab;

  PageController _pageController = PageController();
  PageController get pageController => _pageController;
}
