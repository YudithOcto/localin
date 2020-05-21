import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/news/pages/news_create_article_page.dart';
import 'package:localin/presentation/news/provider/news_header_provider.dart';
import 'package:localin/presentation/news/provider/news_myarticle_provider.dart';
import 'package:localin/presentation/news/provider/news_published_article_provider.dart';
import 'package:localin/presentation/search/search_article/search_article_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class NewsMainHeader extends StatefulWidget {
  @override
  _NewsMainHeaderState createState() => _NewsMainHeaderState();
}

class _NewsMainHeaderState extends State<NewsMainHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'images/news_base.png',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          top: 42.0,
          left: 20.0,
          right: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'News',
                    style: ThemeText.rodinaTitle1
                        .copyWith(color: ThemeColors.black0),
                  ),
                  InkWell(
                    onTap: () async {},
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Create Article',
                          style: ThemeText.sfSemiBoldBody
                              .copyWith(color: ThemeColors.black0),
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        SvgPicture.asset(
                          'images/add_icon.svg',
                          width: 24.0,
                          height: 24.0,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Consumer<NewsHeaderProvider>(
                builder: (context, provider, child) {
                  return Container(
                    height: 48.0,
                    child: ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(3, (index) {
                          return InkWell(
                            onTap: () => provider.setHeaderSelected(index),
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: index == 0 ? 0 : 12.0),
                              alignment: FractionalOffset.center,
                              decoration: BoxDecoration(
                                  color: provider.currentHeaderSelected == index
                                      ? ThemeColors.black0
                                      : ThemeColors.black0.withAlpha(100),
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      provider.iconTab[index],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 13.0),
                                    child: Text(
                                      provider.newsTabTitle[index],
                                      style: ThemeText.sfSemiBoldFootnote,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  loadCreateArticlePage() async {
    if (Provider.of<AuthProvider>(context, listen: false).userModel.status ==
        kUserStatusVerified) {
      final result = await Navigator.of(context)
          .pushNamed(NewsCreateArticlePage.routeName, arguments: {
        NewsCreateArticlePage.previousDraft: null,
      });
      if (result != null) {
        final provider =
            Provider.of<NewsMyArticleProvider>(context, listen: false);
        if (result == 'published') {
          provider.getUserDraftArticle();
          Provider.of<NewsPublishedArticleProvider>(context, listen: false)
              .getUserArticle();
        } else {
          provider.getUserDraftArticle();
        }
      }
    } else {
      CustomToast.showCustomToast(
          context, 'You are required to verify your profile to create article');
    }
  }
}
