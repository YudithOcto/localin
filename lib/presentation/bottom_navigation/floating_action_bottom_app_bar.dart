import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';

class FloatingActionBottomAppBarItem {
  String iconData;
  String text;
  FloatingActionBottomAppBarItem({this.iconData, this.text});
}

class FloatingActionBottomAppBar extends StatefulWidget {
  final List<FloatingActionBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  final int selectedTabIndex;

  FloatingActionBottomAppBar(
      {this.items,
      this.centerItemText,
      this.height,
      this.iconSize,
      this.backgroundColor,
      this.color,
      this.selectedColor,
      this.notchedShape,
      this.selectedTabIndex,
      this.onTabSelected});
  @override
  _FloatingActionBottomAppBarState createState() =>
      _FloatingActionBottomAppBarState();
}

class _FloatingActionBottomAppBarState
    extends State<FloatingActionBottomAppBar> {
  int _selectedIndex = 0;
  final iconActive = [
    'images/feed_active.svg',
    'images/new_active.svg',
    'images/transaction_active.svg',
    'images/inbox_active.svg',
    'images/profile_active.svg',
  ];
  final iconInactive = [
    'images/feed_inactive.svg',
    'images/news_inactive.svg',
    'images/transaction_inactive.svg',
    'images/inbox_inactive.svg',
    'images/profile_inactive.svg',
  ];

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  void dataChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    dataChanged(widget.selectedTabIndex);
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
          item: widget.items[index], index: index, onPressed: _updateIndex);
    });
    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildTabItem(
      {FloatingActionBottomAppBarItem item,
      int index,
      ValueChanged<int> onPressed}) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    String image =
        _selectedIndex == index ? iconActive[index] : iconInactive[index];
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: InkWell(
          onTap: () => onPressed(index),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  '$image',
                  width: 24.0,
                  height: 24.0,
                ),
                SizedBox(
                  height: 7.8,
                ),
                AutoSizeText(item.text,
                    overflow: TextOverflow.fade,
                    minFontSize: 10.0,
                    maxFontSize: 11.0,
                    maxLines: 1,
                    style: ThemeText.sfSemiBoldFootnote)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
