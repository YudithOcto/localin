import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/search/provider/search_article_provider.dart';
import 'package:localin/presentation/search/tag_page/tags_detail_list_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SearchTagResultWidget extends StatefulWidget {
  @override
  _SearchTagResultWidgetState createState() => _SearchTagResultWidgetState();
}

class _SearchTagResultWidgetState extends State<SearchTagResultWidget> {
  bool _isInit = true;
  final ScrollController _searchTagController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      locator<AnalyticsService>().setScreenName(name: 'SearchTagsTab');
      Provider.of<SearchArticleProvider>(context, listen: false).getTags();
      _searchTagController..addListener(_listen);
      _isInit = false;
    }
  }

  _listen() {
    if (_searchTagController.offset >=
        _searchTagController.position.maxScrollExtent) {
      Provider.of<SearchArticleProvider>(context, listen: false)
          .getTags(isRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchArticleProvider>(builder: (context, provider, child) {
      return StreamBuilder<TagState>(
          stream: provider.tagStream,
          builder: (context, snapshot) {
            if (snapshot.data == TagState.isLoading &&
                provider.offsetTags <= 1) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
                controller: _searchTagController,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                children: List.generate(provider.tagsList.length + 1, (index) {
                  if (snapshot.data == TagState.isEmpty) {
                    return Container();
                  } else if (index < provider.tagsList.length) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                TagsDetailListPage.routeName,
                                arguments: {
                                  TagsDetailListPage.tagsModel:
                                      provider.tagsList[index],
                                });
                          },
                          title: Text(
                            '#${provider.tagsList[index].tagName}',
                            style: ThemeText.sfSemiBoldBody
                                .copyWith(color: ThemeColors.brandBlack),
                          ),
                          subtitle: Text(
                            '${provider.tagsList[index].totalArticle} articles',
                            style: ThemeText.sfRegularFootnote
                                .copyWith(color: ThemeColors.black80),
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.all(0.0),
                        ),
                        Divider(
                          thickness: 1.5,
                          color: ThemeColors.black40,
                        ),
                      ],
                    );
                  } else if (provider.isCanLoadMoreTags &&
                      provider.tagsList.length != 5) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }));
          });
    });
  }
}
