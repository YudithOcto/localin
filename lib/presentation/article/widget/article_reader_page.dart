import 'package:flutter/material.dart';
import 'package:localin/presentation/article/widget/recommended_card.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/constants.dart';

class ArticleReaderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(
              Constants.kLargeRandomWords,
              style:
                  kValueStyle.copyWith(fontSize: 14.0, color: Colors.black54),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          RecommendedCard(),
        ],
      ),
    );
  }
}
