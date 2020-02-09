import 'package:flutter/material.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      Provider.of<HomeProvider>(context, listen: false)
          .resetAndGetArticleList();
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 5.0),
          child: Text(
            'Yang Terjadi Di Sekitarmu',
            style: kValueStyle.copyWith(fontSize: 24.0),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Provider.of<HomeProvider>(context).isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.articleDetail != null &&
                            provider.articleDetail.isNotEmpty
                        ? provider.articleDetail.length + 1
                        : 0,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      print(
                          '${provider.total}, $index, ${provider.articleDetail.length}');
                      if (index == provider.total) {
                        return Container();
                      } else if (provider.articleDetail.length == index) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ArticleSingleCard(provider?.articleDetail[index]);
                    },
                  );
                },
              )
      ],
    );
  }
}
