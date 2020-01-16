import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/home/widget/article_single_card.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';

class RowArticle extends StatefulWidget {
  @override
  _RowArticleState createState() => _RowArticleState();
}

class _RowArticleState extends State<RowArticle> {
  final int pageSize = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 15.0),
          child: Text(
            'Yang Terjadi Di Sekitarmu',
            style: kValueStyle.copyWith(fontSize: 24.0),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        PagewiseListView<ArticleDetail>(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          pageSize: pageSize,
          itemBuilder: (context, item, index) {
            return ArticleSingleCard(item);
          },
          pageFuture: (pageIndex) {
            return Provider.of<HomeProvider>(context, listen: false)
                .getArticleList(pageIndex + 1, pageSize);
          },
        )
      ],
    );
  }
}
