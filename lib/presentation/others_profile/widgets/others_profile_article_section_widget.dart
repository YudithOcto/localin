import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/article/shared_article_components/article_single_card.dart';
import 'package:localin/presentation/article/shared_article_components/empty_article.dart';
import 'package:localin/presentation/others_profile/provider/revamp_others_provider.dart';
import 'package:localin/presentation/others_profile/widgets/empty_other_user_article_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';

class OthersProfileArticleSectionWidget extends StatefulWidget {
  final String id;
  final String username;
  OthersProfileArticleSectionWidget(
      {@required this.id, @required this.username});

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
        .getArticleList(isRefresh: isRefresh, id: '${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider =
        Provider.of<RevampOthersProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset('images/star_orange.svg'),
              SizedBox(
                width: 6.0,
              ),
              Text(
                '${widget.username}\'s article',
                style: ThemeText.sfSemiBoldHeadline.copyWith(letterSpacing: .5),
              )
            ],
          ),
          StreamBuilder<OthersProfileState>(
            stream: articleProvider.articleStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == OthersProfileState.NoData) {
                  return EmptyArticle();
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: articleProvider.articleList != null &&
                            articleProvider.articleList.isNotEmpty
                        ? articleProvider.articleList.length + 1
                        : 1,
                    itemBuilder: (context, index) {
                      if (articleProvider.articleList.length == 0) {
                        return EmptyOtherUserArticle();
                      } else if (index < articleProvider.articleList.length) {
                        return ArticleSingleCard(
                          articleProvider.articleList[index],
                        );
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
