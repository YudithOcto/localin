import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/widgets/news_detail/appbar_bookmark_share_action_widget.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_body_content_widget.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_content_bottom_widget.dart';

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
        appBar: CustomAppBar(
          onClickBackButton: () => Navigator.of(context).pop(_articleDetail),
          pageTitle: 'Local News',
          flexSpace: SafeArea(
            child: AppBarBookMarkShareActionWidget(
              articleDetail: _articleDetail,
            ),
          ),
          appBar: AppBar(),
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
