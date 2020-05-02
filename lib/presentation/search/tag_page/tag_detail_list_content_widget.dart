import 'package:flutter/material.dart';
import 'package:localin/components/shared_article_components/article_single_card.dart';
import 'package:localin/components/shared_article_components/empty_article.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/article/tag_model.dart';
import 'package:localin/presentation/search/provider/tag_article_provider.dart';
import 'package:localin/presentation/search/tag_page/empty_article_tag.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

import 'tags_detail_list_page.dart';

class TagDetailListContentWidget extends StatefulWidget {
  @override
  _TagDetailListContentWidgetState createState() =>
      _TagDetailListContentWidgetState();
}

class _TagDetailListContentWidgetState
    extends State<TagDetailListContentWidget> {
  bool _isInit = true;
  Future getArticle;
  TagModel model;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    model = routeArgs[TagsDetailListPage.tagsModel];
    if (_isInit) {
      getArticle = Provider.of<TagArticleProvider>(context, listen: false)
          .getArticleByTag(model.id);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        elevation: 0.0,
        titleSpacing: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: Text(
          '#${model.tagName}',
          style: ThemeText.sfMediumHeadline,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Text(
              '${model?.totalArticle} articles',
              style: ThemeText.sfRegularFootnote
                  .copyWith(color: ThemeColors.black80),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ArticleDetail>>(
                future: getArticle,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot?.data?.length,
                        itemBuilder: (context, index) {
                          return ArticleSingleCard(snapshot?.data[index]);
                        },
                      );
                    } else {
                      return EmptyArticleByTag();
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }
}
