import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/presentation/news/pages/news_detail_page.dart';
import 'package:localin/presentation/news/provider/news_detail_provider.dart';
import 'package:localin/presentation/news/widgets/news_detail/appbar_bookmark_share_action_widget.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_body_content_widget.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_content_bottom_widget.dart';
import 'package:localin/presentation/shared_widgets/empty_article_with_custom_message.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsDetailContentWidget extends StatefulWidget {
  final String videoUrl;

  NewsDetailContentWidget({this.videoUrl});

  @override
  _NewsDetailContentWidgetState createState() =>
      _NewsDetailContentWidgetState();
}

class _NewsDetailContentWidgetState extends State<NewsDetailContentWidget> {
  Future getArticleDetail;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      String articleId = routeArgs[NewsDetailPage.newsSlug];
      getArticleDetail = Provider.of<NewsDetailProvider>(context, listen: false)
          .getArticleDetail(articleId);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsDetailProvider>(
      builder: (context, provider, child) {
        return widget.videoUrl != null && widget.videoUrl.isNotEmpty
            ? YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: provider.controller,
                ),
                builder: (context, player) {
                  return _buildContent(provider, player);
                },
                onEnterFullScreen: () {
                  provider.controller.pause();
                },
                onExitFullScreen: () {
                  provider.controller.pause();
                },
              )
            : _buildContent(provider, null);
      },
    );
  }

  _buildContent(NewsDetailProvider provider, Widget player) {
    return WillPopScope(
      onWillPop: () async {
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          await SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp]);
        } else {
          Navigator.of(context).pop(provider.articleDetail);
        }
        return false;
      },
      child: Scaffold(
          appBar: CustomAppBar(
            onClickBackButton: () =>
                Navigator.of(context).pop(provider.articleDetail),
            pageTitle: 'Local News',
            flexSpace: SafeArea(
              child: AppBarBookMarkShareActionWidget(
                articleDetail: provider.articleDetail,
                valueChanged: (v) => provider.changeBookmark = v,
              ),
            ),
            appBar: AppBar(),
          ),
          body: FutureBuilder<ArticleBaseResponse>(
            future: getArticleDetail,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: NewsDetailBodyContentWidget(
                          articleDetail: snapshot.data.detail,
                          youtubeWidget: player,
                        ),
                      ),
                      NewsDetailContentBottomWidget(
                        articleDetail: snapshot.data.detail,
                      ),
                    ],
                  );
                } else {
                  return EmptyArticleWithCustomMessage(
                    title: 'Can\'t find news',
                    message: 'Read news from other page',
                  );
                }
              }
            },
          )),
    );
  }
}
