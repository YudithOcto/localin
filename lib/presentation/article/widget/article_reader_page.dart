import 'package:flutter/material.dart';
import 'package:localin/presentation/article/widget/recommended_card.dart';
import 'package:localin/provider/article/article_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:localin/utils/constants.dart';

class ArticleReaderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ArticleDetailProvider>(context);
    return Container(
      width: double.infinity,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: double.infinity,
              child: Text(
                '${state?.articleModel?.description}',
                style:
                    kValueStyle.copyWith(fontSize: 14.0, color: Colors.black54),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Visibility(visible: false, child: RecommendedCard()),
        ],
      ),
    );
  }
}
