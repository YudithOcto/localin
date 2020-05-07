import 'package:flutter/material.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/presentation/news/provider/news_detail_provider.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_content_widget.dart';
import 'package:provider/provider.dart';

class NewsDetailPage extends StatelessWidget {
  static const routeName = '/newsDetailPage';
  static const newsSlug = 'newsSlug';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsDetailProvider>(
          create: (_) => NewsDetailProvider(),
        )
      ],
      child: NewsDetailContentWrapperLoadingWidget(),
    );
  }
}

class NewsDetailContentWrapperLoadingWidget extends StatefulWidget {
  @override
  _NewsDetailContentWrapperLoadingWidgetState createState() =>
      _NewsDetailContentWrapperLoadingWidgetState();
}

class _NewsDetailContentWrapperLoadingWidgetState
    extends State<NewsDetailContentWrapperLoadingWidget> {
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
    return FutureBuilder<ArticleBaseResponse>(
      future: getArticleDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            return NewsDetailContentWidget(
              articleDetail: snapshot?.data?.detail,
            );
          } else {
            return Container();
          }
        }
      },
    );
  }
}
