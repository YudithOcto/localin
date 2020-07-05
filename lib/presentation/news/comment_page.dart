import 'package:flutter/material.dart';
import 'package:localin/presentation/news/provider/comment_provider.dart';
import 'package:localin/presentation/news/widgets/comments/article_comment_content_wrapper.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  static const routeName = 'CommentPage';
  static const articleDetail = 'articleDetail';
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black20,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        elevation: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        titleSpacing: 0.0,
        title: Text(
          'Comments',
          style: ThemeText.sfMediumHeadline,
        ),
      ),
      body: ChangeNotifierProvider<CommentProvider>(
        create: (_) => CommentProvider(),
        child: ArticleCommentContentWrapper(),
      ),
    );
  }
}
