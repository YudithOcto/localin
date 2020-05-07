import 'package:flutter/material.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/widgets/news_detail/appbar_bookmark_share_action_widget.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_body_content_widget.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_content_bottom_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class NewsDetailContentWidget extends StatefulWidget {
  final ArticleDetail articleDetail;
  NewsDetailContentWidget({this.articleDetail});

  @override
  _NewsDetailContentWidgetState createState() =>
      _NewsDetailContentWidgetState();
}

class _NewsDetailContentWidgetState extends State<NewsDetailContentWidget> {
  bool isInit = true;
  ArticleDetail _articleDetail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      _articleDetail = widget.articleDetail ?? ArticleDetail();
      isInit = false;
    }
  }

  Future<bool> _onWillPop() {
    Navigator.of(context).pop(_articleDetail);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.black0,
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(_articleDetail),
            child: Icon(
              Icons.arrow_back,
              color: ThemeColors.black80,
            ),
          ),
          titleSpacing: 0.0,
          title: Container(
            margin: EdgeInsets.only(right: 80.0),
            child: Text(
              'Local News',
              overflow: TextOverflow.ellipsis,
              style: ThemeText.sfMediumHeadline,
            ),
          ),
          flexibleSpace: SafeArea(
            child: AppBarBookMarkShareActionWidget(
              articleDetail: _articleDetail,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: NewsDetailBodyContentWidget(
                articleDetail: _articleDetail,
              ),
            ),
            NewsDetailContentBottomWidget(
              articleDetail: _articleDetail,
            ),
          ],
        ),
      ),
    );
  }
}
