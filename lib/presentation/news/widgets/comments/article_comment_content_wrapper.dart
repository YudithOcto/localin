import 'package:flutter/material.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/pages/news_comment_page.dart';
import 'package:localin/presentation/news/provider/comment_provider.dart';
import 'package:localin/presentation/news/widgets/comments/article_comment_description.dart';
import 'package:localin/presentation/news/widgets/comments/article_comment_form.dart';
import 'package:localin/presentation/news/widgets/comments/article_comment_list.dart';
import 'package:provider/provider.dart';

class ArticleCommentContentWrapper extends StatefulWidget {
  @override
  _ArticleCommentContentWrapperState createState() =>
      _ArticleCommentContentWrapperState();
}

class _ArticleCommentContentWrapperState
    extends State<ArticleCommentContentWrapper> {
  ArticleDetail _articleDetail;
  bool isInit = true;
  final ScrollController controller = ScrollController();

  @override
  void didChangeDependencies() {
    if (isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _articleDetail = routeArgs[NewsCommentPage.articleDetail];
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: 80.0,
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            controller: controller,
            children: <Widget>[
              ArticleCommentDescription(detail: _articleDetail),
              ArticleCommentList(
                controller: controller,
                articleId: _articleDetail.id,
              ),
            ],
          ),
        ),
        Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: ArticleCommentForm(
              controller: controller,
            )),
      ],
    );
  }
}
