import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/news/provider/news_myarticle_provider.dart';
import 'package:localin/presentation/news/provider/news_published_article_provider.dart';
import 'package:localin/presentation/shared_widgets/article_single_card.dart';
import 'package:localin/presentation/shared_widgets/empty_article.dart';
import 'package:provider/provider.dart';

class MyArchiveArticle extends StatefulWidget {
  @override
  _MyArchiveArticleState createState() => _MyArchiveArticleState();
}

class _MyArchiveArticleState extends State<MyArchiveArticle>
    with AutomaticKeepAliveClientMixin {
  bool _isInit = true;
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      locator<AnalyticsService>().setScreenName(name: 'ArticleTrashTab');
      loadArticle();
      _scrollController = ScrollController()..addListener(_listener);
      _isInit = false;
    }
  }

  _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        Provider.of<NewsMyArticleProvider>(context, listen: false)
            .canLoadMoreArchiveArticleList) {
      loadArticle(isRefresh: false);
    }
  }

  loadArticle({bool isRefresh = true}) {
    Provider.of<NewsMyArticleProvider>(context, listen: false)
        .getUserTrashArticle(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          loadArticle(isRefresh: true);
        });
      },
      child: Consumer<NewsMyArticleProvider>(
        builder: (context, provider, child) {
          return StreamBuilder<archiveState>(
            stream: provider.archiveStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  provider.userArticleArchiveOffset <= 1) {
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
                  itemCount: provider.userArticleArchiveList.length + 1 ?? 1,
                  itemBuilder: (context, index) {
                    if (snapshot.hasData &&
                        snapshot.data == archiveState.empty) {
                      return EmptyArticle();
                    } else if (index < provider.userArticleArchiveList.length) {
                      return ArticleSingleCard(
                        provider.userArticleArchiveList[index],
                        imageFit: BoxFit.cover,
                        popupItem: ['Unarchive'],
                        showPopup: (v) {
                          final value = v.values.first;
                          showDialogUnArchive(value.slug);
                        },
                      );
                    } else if (provider.canLoadMoreArchiveArticleList) {
                      /// This load more should be load more to trashed article
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

  showDialogUnArchive(String slug) async {
    final result = await CustomDialog.showCustomDialogWithMultipleButton(
      context,
      isDismissible: false,
      title: 'Unarchive this article?',
      message: 'This article will be published again',
      cancelText: 'Cancel',
      okText: 'Publish',
      onCancel: () => Navigator.of(context).pop(false),
      okCallback: () => Navigator.of(context).pop(true),
    );

    if (result != null && result) {
      final provider =
          Provider.of<NewsMyArticleProvider>(context, listen: false);
      CustomDialog.showLoadingDialog(context, message: 'Loading');
      final response = await provider.unarchiveArticle(slug);
      CustomToast.showCustomBookmarkToast(context, '${response.error}');
      provider.getUserTrashArticle();
      Provider.of<NewsPublishedArticleProvider>(context, listen: false)
          .getUserArticle();
      CustomDialog.closeDialog(context);
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
