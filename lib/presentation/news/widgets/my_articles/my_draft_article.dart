import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/news/pages/news_create_article_page.dart';
import 'package:localin/presentation/news/provider/news_myarticle_provider.dart';
import 'package:localin/presentation/news/provider/news_published_article_provider.dart';
import 'package:localin/presentation/news/widgets/my_articles/draft_article_single_card.dart';
import 'package:localin/presentation/shared_widgets/empty_article.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class MyDraftArticle extends StatefulWidget {
  @override
  _MyDraftArticleState createState() => _MyDraftArticleState();
}

class _MyDraftArticleState extends State<MyDraftArticle>
    with AutomaticKeepAliveClientMixin {
  bool _isInit = true;
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      locator<AnalyticsService>().setScreenName(name: 'ArticleDraftTab');
      loadArticle();
      _scrollController = ScrollController()..addListener(_listener);
      _isInit = false;
    }
  }

  _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        Provider.of<NewsMyArticleProvider>(context, listen: false)
            .isCanLoadMoreDraftArticle) {
      loadArticle(isRefresh: false);
    }
  }

  loadArticle({bool isRefresh = true}) {
    Provider.of<NewsMyArticleProvider>(context, listen: false)
        .getUserDraftArticle(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        loadArticle(isRefresh: true);
      },
      child: Consumer<NewsMyArticleProvider>(
        builder: (context, provider, child) {
          return StreamBuilder<draftState>(
            stream: provider.draftStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  provider.userArticleDraftOffset <= 1) {
                return Container(
                  alignment: FractionalOffset.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                  itemCount: provider.userArticleDraftList.isNotNullNorEmpty
                      ? provider.userArticleDraftList.length + 1
                      : 1,
                  itemBuilder: (context, index) {
                    if (snapshot.hasData && snapshot.data == draftState.empty) {
                      return EmptyArticle(
                        onPressed: () => loadCreateArticlePage(),
                      );
                    } else if (index < provider.userArticleDraftList.length) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: DraftArticleSingleCard(
                          model: provider?.userArticleDraftList[index],
                        ),
                      );
                    } else if (provider.isCanLoadMoreDraftArticle) {
                      /// This load more should be load more to draft
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
            },
          );
        },
      ),
    );
  }

  loadCreateArticlePage() async {
    if (Provider.of<AuthProvider>(context, listen: false).userModel.status ==
        kUserStatusVerified) {
      final result = await Navigator.of(context)
          .pushNamed(NewsCreateArticlePage.routeName, arguments: {
        NewsCreateArticlePage.previousDraft: null,
      });
      if (result != null) {
        final provider =
            Provider.of<NewsMyArticleProvider>(context, listen: false);
        if (result == 'published') {
          provider.getUserDraftArticle();
          Provider.of<NewsPublishedArticleProvider>(context, listen: false)
              .getUserArticle();
        } else {
          provider.getUserDraftArticle();
        }
      }
    } else {
      CustomToast.showCustomBookmarkToast(
          context, 'Verify Your Account To Create a Article');
    }
  }

  @override
  bool get wantKeepAlive => true;
}

extension on List {
  bool get isNotNullNorEmpty {
    return this != null && this.isNotEmpty;
  }
}
