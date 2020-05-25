import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/article/darft_article_model.dart';
import 'package:localin/presentation/news/provider/create_article_provider.dart';
import 'package:localin/presentation/news/widgets/create_article/create_article_wrapper_widget.dart';
import 'package:provider/provider.dart';

class NewsCreateArticlePage extends StatelessWidget {
  static const routeName = 'CreateArticlePage';
  static const previousDraft = 'PreviousDraft';
  static const fromPublishedArticle = 'fromPublishedArticle';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    DraftArticleModel _detail =
        routeArgs[NewsCreateArticlePage.previousDraft] ?? null;
    bool fromPublishedArticle =
        routeArgs[NewsCreateArticlePage.fromPublishedArticle] ?? false;
    return ChangeNotifierProvider<CreateArticleProvider>(
      create: (_) => CreateArticleProvider(
          previousArticleModel: _detail,
          isFromPublishedArticle: fromPublishedArticle),
      child: CreateArticleWrapperWidget(),
    );
  }
}
