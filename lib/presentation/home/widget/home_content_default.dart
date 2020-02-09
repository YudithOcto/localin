import 'package:flutter/material.dart';
import 'package:localin/presentation/home/widget/row_article.dart';
import 'package:localin/presentation/home/widget/row_community.dart';
import 'package:localin/presentation/home/widget/row_quick_menu.dart';

class HomeContentDefault extends StatelessWidget {
  final bool isHomePage;
  final VoidCallback onSearchBarPressed;
  HomeContentDefault({this.isHomePage, this.onSearchBarPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(
        children: <Widget>[
          RowQuickMenu(
            isHomePage: isHomePage,
            onPressed: onSearchBarPressed,
          ),
          containerDivider(25.0),
          //RowCommunity(),
          //containerDivider(5.0),
          RowArticle()
        ],
      ),
    );
  }

  containerDivider(double verticalHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalHeight),
      color: Colors.black12.withOpacity(0.2),
      width: double.infinity,
      height: 1.0,
    );
  }
}
