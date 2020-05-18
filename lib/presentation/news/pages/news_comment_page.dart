import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:localin/presentation/news/provider/comment_provider.dart';
import 'package:localin/presentation/news/widgets/comments/article_comment_content_wrapper.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class NewsCommentPage extends StatefulWidget {
  static const routeName = 'CommentPage';
  static const articleDetail = 'articleDetail';
  @override
  _NewsCommentPageState createState() => _NewsCommentPageState();
}

class _NewsCommentPageState extends State<NewsCommentPage> {
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          FocusScope.of(context).unfocus();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final articleDetail = routeArgs[NewsCommentPage.articleDetail];
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
        create: (_) => CommentProvider(
            articleDetail: articleDetail,
            profile:
                Provider.of<AuthProvider>(context, listen: false).userModel),
        child: ArticleCommentContentWrapper(),
      ),
    );
  }
}
