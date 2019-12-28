import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/presentation/home/widget/row_article.dart';
import 'package:localin/presentation/home/widget/row_community.dart';
import 'package:localin/presentation/home/widget/row_quick_menu.dart';

class HomeContentDefault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay: 0.5,
      fadeDirection: FadeDirection.bottom,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RowQuickMenu(),
            containerDivider(),
            RowCommunity(),
            Divider(
              color: Colors.black26,
            ),
            RowArticle()
          ],
        ),
      ),
    );
  }

  containerDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
      color: Colors.black26,
      width: double.infinity,
      height: 1.0,
    );
  }
}
