import 'package:flutter/material.dart';
import 'package:localin/presentation/search/provider/tag_article_provider.dart';
import 'package:localin/presentation/search/tag_page/tag_detail_list_content_widget.dart';
import 'package:provider/provider.dart';

class TagsDetailListPage extends StatefulWidget {
  static const routeName = 'TagDetailPage';
  static const tagsModel = 'tagsModel';

  @override
  _TagsDetailListPageState createState() => _TagsDetailListPageState();
}

class _TagsDetailListPageState extends State<TagsDetailListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TagArticleProvider>(
      create: (_) => TagArticleProvider(),
      child: TagDetailListContentWidget(),
    );
  }
}
