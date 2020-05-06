import 'package:flutter/material.dart';

class NewsHeaderProvider with ChangeNotifier {
  int _headerCurrentSelected = 0;
  int get currentHeaderSelected => _headerCurrentSelected;
  void setHeaderSelected(int index) {
    _headerCurrentSelected = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  List<String> _newsTab = ['Latest', 'My Articles', 'Collections'];
  List<String> get newsTabTitle => _newsTab;

  List<String> _iconsTab = [
    'images/article_latest_icon.svg',
    'images/article_myarticle_icon.svg',
    'images/article_collection_icon.svg'
  ];
  List<String> get iconTab => _iconsTab;

  PageController _pageController = PageController();
  PageController get pageController => _pageController;
}
