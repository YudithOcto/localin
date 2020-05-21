import 'package:flutter/material.dart';
import 'package:localin/presentation/article/shared_article_components/article_single_card.dart';
import 'package:localin/presentation/article/shared_article_components/empty_article.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/article/tag_model_model.dart';
import 'package:localin/presentation/search/provider/tag_article_provider.dart';
import 'package:localin/presentation/shared_widgets/empty_article_with_custom_message.dart';
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
  final ScrollController _scrollController = ScrollController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    model = routeArgs[TagsDetailListPage.tagsModel];
    if (_isInit) {
      getArticle = Provider.of<TagArticleProvider>(context, listen: false)
          .getArticleByTag(model.id);
      _scrollController..addListener(_scrollListener);
      _isInit = false;
    }
  }

  _scrollListener() {
    final provider = Provider.of<TagArticleProvider>(context, listen: false);
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        provider.canLoadMoreArticle) {
      setState(() {
        getArticle = provider.getArticleByTag(model.id, isRefresh: false);
      });
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
                  final provider =
                      Provider.of<TagArticleProvider>(context, listen: false);
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      provider.offsetRequest <= 1) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.length + 1 ?? 1,
                      itemBuilder: (context, index) {
                        if (provider.offsetRequest <= 2 &&
                            snapshot.data.length == 0) {
                          return EmptyArticle();
                        } else if (index < snapshot?.data?.length) {
                          return ArticleSingleCard(snapshot?.data[index]);
                        } else if (provider.canLoadMoreArticle) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
