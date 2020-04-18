import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/article/pages/create_article_page.dart';
import 'package:localin/presentation/home/widget/articles/article_single_card.dart';
import 'package:localin/presentation/home/widget/articles/empty_article.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
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
          .getArticleList(isRefresh: true);
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SvgPicture.asset('images/star_orange.svg'),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'What\'s on',
                    textAlign: TextAlign.center,
                    style: ThemeText.sfSemiBoldHeadline,
                  )
                ],
              ),
              InkWell(
                onTap: () async {
                  final result = await Navigator.of(context)
                      .pushNamed(CreateArticlePage.routeName);
                  if (result != null) {
                    /// refresh current page
                  }
                },
                child: Text(
                  'More articles',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfSemiBoldHeadline
                      .copyWith(color: ThemeColors.primaryBlue),
                ),
              )
            ],
          ),
          StreamBuilder<articleState>(
            stream:
                Provider.of<HomeProvider>(context, listen: false).articleStream,
            builder: (context, snapshot) {
              final homeProvider = Provider.of<HomeProvider>(context);
              if (snapshot.hasData) {
                if (snapshot.data == articleState.NoData) {
                  return EmptyArticle();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: homeProvider.articleDetailList != null &&
                            homeProvider.articleDetailList.isNotEmpty
                        ? homeProvider.articleDetailList.length + 1
                        : 1,
                    itemBuilder: (context, index) {
                      if (index < homeProvider.articleDetailList.length) {
                        return ArticleSingleCard(
                            homeProvider.articleDetailList[index]);
                      } else if (homeProvider.canLoadMore) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
