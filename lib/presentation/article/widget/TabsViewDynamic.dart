import 'package:flutter/material.dart';

class TabsViewDynamic extends StatelessWidget {
  TabsViewDynamic(
      {Key key,
      @required this.tabIndex,
      @required this.firstTab,
      @required this.secondTab})
      : super(key: key);

  final int tabIndex;
  final Widget firstTab;
  final Widget secondTab;

  @override
  Widget build(BuildContext context) {
    final sizeConfig = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        AnimatedContainer(
          child: firstTab,
          width: sizeConfig.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          transform: Matrix4.translationValues(
              tabIndex == 0 ? 0 : -sizeConfig.width, 0, 0),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        ),
        AnimatedContainer(
          child: secondTab,
          width: sizeConfig.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          transform: Matrix4.translationValues(
              tabIndex == 1 ? 0 : sizeConfig.width, 0, 0),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        )
      ],
    );
  }
}
