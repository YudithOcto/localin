import 'package:flutter/material.dart';
import 'package:localin/components/shared_article_components/article_single_card.dart';
import 'package:localin/components/shared_article_components/empty_article.dart';
import 'package:localin/presentation/profile/provider/revamp_others_provider.dart';
import 'package:provider/provider.dart';

class OthersProfileArticleSectionWidget extends StatefulWidget {
  @override
  _OthersProfileArticleSectionWidgetState createState() =>
      _OthersProfileArticleSectionWidgetState();
}

class _OthersProfileArticleSectionWidgetState
    extends State<OthersProfileArticleSectionWidget> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      _loadArticleData();
      isInit = false;
    }
  }

  _loadArticleData({bool isRefresh = false}) {
    Provider.of<RevampOthersProvider>(context, listen: false)
        .getArticleList(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider =
        Provider.of<RevampOthersProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder<OthersProfileState>(
        stream: articleProvider.articleStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == OthersProfileState.NoData) {
              return EmptyArticle();
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: articleProvider.articleList != null &&
                        articleProvider.articleList.isNotEmpty
                    ? articleProvider.articleList.length + 1
                    : 1,
                itemBuilder: (context, index) {
                  if (articleProvider.articleList.length == 0) {
                    return EmptyArticle();
                  } else if (index < articleProvider.articleList.length) {
                    return ArticleSingleCard(
                        articleProvider.articleList[index]);
                  } else if (articleProvider.canLoadMoreArticle) {
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
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
