import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  final Function onClickBackButton;
  final String pageTitle;
  final Widget flexSpace;
  final AppBar appBar;
  final Widget leadingIcon;
  final TextStyle titleStyle;
  final PreferredSizeWidget bottomAppBar;

  CustomAppBar({
    Key key,
    @required this.appBar,
    this.onClickBackButton,
    @required this.pageTitle,
    this.flexSpace,
    this.leadingIcon,
    this.titleStyle = ThemeText.sfMediumHeadline,
    this.bottomAppBar,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.black0,
      elevation: 0,
      leading: leadingIcon == null
          ? InkWell(
              onTap: onClickBackButton,
              child: Icon(
                Icons.arrow_back,
                color: ThemeColors.black80,
              ),
            )
          : leadingIcon,
      titleSpacing: 0.0,
      title: Container(
        margin: EdgeInsets.only(right: 80.0),
        child: Text(
          '$pageTitle',
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
      ),
      flexibleSpace: flexSpace,
      bottom: bottomAppBar,
    );
  }

  @override
  Widget get child => null;

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
