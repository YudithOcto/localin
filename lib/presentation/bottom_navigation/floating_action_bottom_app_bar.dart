import 'package:flutter/material.dart';

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
                ImageIcon(
                  ExactAssetImage(item.iconData),
                  color: color,
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text(
                  item.text,
                  style: TextStyle(
                      color: color,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
