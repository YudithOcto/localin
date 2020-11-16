import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/article/darft_article_model.dart';
import 'package:localin/presentation/news/pages/news_create_article_page.dart';
import 'package:localin/presentation/news/provider/news_myarticle_provider.dart';
import 'package:localin/presentation/news/provider/news_published_article_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

const popupText = ['Edit', 'Delete'];

class DraftArticleSingleCard extends StatelessWidget {
  final DraftArticleModel model;

  DraftArticleSingleCard({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0, top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          bigImages(context),
          SizedBox(
            height: 12.0,
          ),
          InkWell(
            onTap: () => openCreateArticlePage(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${parseHtml(model?.title)}',
                        style: ThemeText.rodinaTitle3
                            .copyWith(color: ThemeColors.black100),
                      ),
                      Text(
                        '${DateHelper.timeAgo(DateTime.fromMillisecondsSinceEpoch(model?.dateTime))}',
                        style: ThemeText.sfMediumBody
                            .copyWith(color: ThemeColors.black80),
                      )
                    ],
                  ),
                ),
                PopupMenuButton(
                    padding: EdgeInsets.all(0.0),
                    onSelected: (v) {
                      if (v == popupText[0]) {
                        openCreateArticlePage(context);
                      } else {
                        deleteDraftArticle(context);
                      }
                    },
                    itemBuilder: (context) {
                      return popupText
                          .map((e) => PopupMenuItem(
                                value: e,
                                child: Text('$e'),
                              ))
                          .toList();
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bigImages(BuildContext context) {
    return InkWell(
      onTap: () async {
        openCreateArticlePage(context);
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: model.resultImage.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(model?.resultImage[0])),
                ),
              )
            : emptyImage(),
      ),
    );
  }

  emptyImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: ThemeColors.black80,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.image,
            color: ThemeColors.black40,
            size: 60.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Empty Image',
            style: ThemeText.rodinaTitle1.copyWith(color: ThemeColors.black0),
          ),
        ],
      ),
    );
  }

  openCreateArticlePage(BuildContext context) async {
    final result = await Navigator.of(context)
        .pushNamed(NewsCreateArticlePage.routeName, arguments: {
      NewsCreateArticlePage.previousDraft: model,
    });
    if (result != null) {
      if (result == 'draft') {
        Provider.of<NewsMyArticleProvider>(context, listen: false)
            .getUserDraftArticle();
      } else {
        Provider.of<NewsMyArticleProvider>(context, listen: false)
            .getUserDraftArticle();
        Provider.of<NewsPublishedArticleProvider>(context, listen: false)
            .getUserArticle();
      }
    }
  }

  deleteDraftArticle(BuildContext context) async {
    final result =
        await Provider.of<NewsMyArticleProvider>(context, listen: false)
            .deleteDraftArticle(model);
    if (result > 0) {
      CustomToast.showCustomToast(context, 'Draft Deleted');
      Provider.of<NewsMyArticleProvider>(context, listen: false)
          .getUserDraftArticle();
    }
  }

  parseHtml(String data) {
    final doc = parser.parse(data);
    return parser.parse(doc.body.text).documentElement.text;
  }
}
