import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/home/widget/articles/article_single_card.dart';
import 'package:localin/presentation/home/widget/articles/empty_article.dart';
import 'package:localin/presentation/profile/profile_page.dart';
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
              Text(
                'More articles',
                textAlign: TextAlign.center,
                style: ThemeText.sfSemiBoldHeadline
                    .copyWith(color: ThemeColors.primaryBlue),
              )
            ],
          ),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              if (provider.articleDetail == null) {
                return EmptyArticle();
              } else {
                return ListView.builder(
                  itemCount: provider.articleDetail != null &&
                          provider.articleDetail.isNotEmpty
                      ? provider.articleDetail.length + 1
                      : 0,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
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
              }
            },
          )
        ],
      ),
    );
  }
}
