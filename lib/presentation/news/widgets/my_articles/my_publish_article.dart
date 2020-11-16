import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/locator.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/pages/news_create_article_page.dart';
import 'package:localin/presentation/news/provider/news_myarticle_provider.dart';
import 'package:localin/presentation/news/provider/news_published_article_provider.dart';
import 'package:localin/presentation/shared_widgets/article_single_card.dart';
import 'package:localin/presentation/shared_widgets/empty_article.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class MyPublishArticle extends StatefulWidget {
  @override
  _MyPublishArticleState createState() => _MyPublishArticleState();
}

class _MyPublishArticleState extends State<MyPublishArticle>
    with AutomaticKeepAliveClientMixin {
  Future getPublishedArticle;
  bool _isInit = true;
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      locator<AnalyticsService>().setScreenName(name: 'ArticlePublishTab');
      loadArticle();
      _scrollController = ScrollController()..addListener(_listener);
      _isInit = false;
    }
  }

  _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        Provider.of<NewsPublishedArticleProvider>(context, listen: false)
            .canLoadMoreArticleList) {
      loadArticle(isRefresh: false);
    }
  }

  loadArticle({bool isRefresh = true}) {
    getPublishedArticle =
        Provider.of<NewsPublishedArticleProvider>(context, listen: false)
            .getUserArticle(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        loadArticle(isRefresh: true);
      },
      child: StreamBuilder<publishedArticleState>(
        stream:
            Provider.of<NewsPublishedArticleProvider>(context).publishedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              Provider.of<NewsPublishedArticleProvider>(context, listen: false)
                      .userArticleOffset <=
                  1) {
            return Container(
              alignment: FractionalOffset.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4),
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<NewsPublishedArticleProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  primary: false,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                  itemCount: provider.userArticleList.isNotNullNorEmpty
                      ? provider.userArticleList.length + 1
                      : 1,
                  itemBuilder: (context, index) {
                    if (snapshot.hasData &&
                        snapshot.data == publishedArticleState.empty) {
                      return EmptyArticle(
                        onPressed: () => loadCreateArticlePage(),
                      );
                    } else if (index < provider.userArticleList.length) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ArticleSingleCard(
                          provider.userArticleList[index],
                          popupItem: ['Edit', 'Archive'],
                          imageFit: BoxFit.cover,
                          showPopup: (v) {
                            if (v != null) {
                              final key = v.keys.first;
                              final value = v.values.first;
                              if (key == 'Edit') {
                                editPublishedArticle(value);
                              } else {
                                provider.deleteArticle(value.id);
                              }
                            }
                          },
                        ),
                      );
                    } else if (provider.canLoadMoreArticleList) {
                      /// This load more should be load more to published article
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
              },
            );
          }
        },
      ),
    );
  }

  editPublishedArticle(ArticleDetail model) async {
    CustomDialog.showLoadingDialog(context, message: 'Opening Article');
    final convertDraftModel =
        await Provider.of<NewsPublishedArticleProvider>(context, listen: false)
            .getArticleModel(model);
    final result = await Navigator.of(context)
        .pushNamed(NewsCreateArticlePage.routeName, arguments: {
      NewsCreateArticlePage.previousDraft: convertDraftModel,
      NewsCreateArticlePage.fromPublishedArticle: true,
    });
    CustomDialog.closeDialog(context);
    if (result != null) {
      Provider.of<NewsMyArticleProvider>(context, listen: false)
          .getUserDraftArticle();
      Provider.of<NewsPublishedArticleProvider>(context, listen: false)
          .getUserArticle();
    }
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
