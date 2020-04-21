import 'package:flutter/material.dart';
import 'package:localin/presentation/home/widget/articles/row_article.dart';
import 'package:localin/presentation/home/widget/community/row_community.dart';
import 'package:localin/presentation/home/widget/row_quick_menu.dart';
import 'package:localin/presentation/home/widget/row_user_data.dart';

class HomeContentDefault extends StatelessWidget {
  final bool isHomePage;
  HomeContentDefault({this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 50.0),
      children: <Widget>[
        RowUserData(),
        RowCommunity(),
        SizedBox(
          height: 12.0,
        ),
        RowArticle()
      ],
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
