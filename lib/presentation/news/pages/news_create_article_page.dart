import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/presentation/news/provider/create_article_provider.dart';
import 'package:localin/presentation/news/widgets/create_article/create_article_wrapper_widget.dart';
import 'package:provider/provider.dart';

class NewsCreateArticlePage extends StatelessWidget {
  static const routeName = 'CreateArticlePage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateArticleProvider>(
      create: (_) => CreateArticleProvider(),
      child: CreateArticleWrapperWidget(),
    );
  }
}
