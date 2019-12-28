import 'package:flutter/material.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/presentation/home/widget/article_single_card.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';

class RowArticle extends StatefulWidget {
  @override
  _RowArticleState createState() => _RowArticleState();
}

class _RowArticleState extends State<RowArticle> {
  bool isInit = true;
  Future<ArticleBaseResponse> articleFuture;

  @override
  void didChangeDependencies() {
    if (isInit) {
      articleFuture =
          Provider.of<HomeProvider>(context, listen: false).getArticleList();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(12.0),
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            'Yang Terjadi Di Sekitarmu',
            style: kValueStyle.copyWith(fontSize: 24.0),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        FutureBuilder<ArticleBaseResponse>(
            future: articleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children:
                      List.generate(snapshot?.data?.data?.length, (index) {
                    return ArticleSingleCard(
                        index, snapshot?.data?.data[index]);
                  }),
                );
              }
            }),
      ],
    );
  }
}
