import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSize {
  final AppBar appBar;
  final List<Widget> widgets;

  const BaseAppBar({Key key, this.appBar, this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 5.0,
      backgroundColor: Theme.of(context).canvasColor,
      title: Image.asset(
        'images/app_bar_logo.png',
        width: MediaQuery.of(context).size.width * 0.3,
        height: 50.0,
      ),
    );
  }

  @override
  Widget get child => null;

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
