import 'package:flutter/material.dart';
import 'package:localin/presentation/search/provider/search_article_provider.dart';
import 'package:localin/presentation/search/tag_page/tags_detail_list_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SearchTagListWidget extends StatefulWidget {
  @override
  _SearchTagListWidgetState createState() => _SearchTagListWidgetState();
}

class _SearchTagListWidgetState extends State<SearchTagListWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchArticleProvider>(builder: (context, provider, child) {
      return StreamBuilder<TagState>(
          stream: provider.tagStream,
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasData && snapshot.data == TagState.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                children: List.generate(provider.tagsList.length, (index) {
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
                }));
          });
    });
  }
}
