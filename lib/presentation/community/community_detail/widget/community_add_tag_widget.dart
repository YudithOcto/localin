import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/community/community_detail/provider/community_create_post_provider.dart';
import 'package:localin/presentation/news/provider/create_article_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityAddTagWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Subtitle(
            title: 'TAGS',
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            'Add tag for your community',
            style: ThemeText.sfRegularFootnote
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 12.0,
          ),
          Consumer<CommunityCreatePostProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      itemCount: provider.selectedTags.length + 1,
                      itemBuilder: (context, index) {
                        if (index == provider.selectedTags.length) {
                          return Visibility(
                            visible: provider.selectedTags.length < 10,
                            child: Container(
                              width: 100,
                              margin: EdgeInsets.only(
                                  left: index == 0 ? 0.0 : 12.0),
                              child: TextFormField(
                                controller: provider.searchTagController,
                                style: ThemeText.sfSemiBoldFootnote
                                    .copyWith(color: ThemeColors.black80),
                                onFieldSubmitted: (v) {
                                  if (v.isNotEmpty) {
                                    provider.addTags =
                                        provider.searchTagController.text;
                                    provider.searchTagController.clear();
                                    FocusScope.of(context).unfocus();
                                    provider.clearListTags();
                                  }
                                },
                                onChanged: (v) {
                                  if (v.isNotEmpty &&
                                      (v.endsWith(' ') || v.endsWith(','))) {
                                    provider.addTags = provider
                                        .searchTagController.text
                                        .substring(
                                            0,
                                            provider.searchTagController.text
                                                    .length -
                                                1);
                                    provider.searchTagController.clear();
                                    FocusScope.of(context).unfocus();
                                    provider.clearListTags();
                                  }
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: ThemeText.sfSemiBoldFootnote
                                        .copyWith(color: ThemeColors.black80),
                                    hintText:
                                        'add ${provider.selectedTags.length > 0 ? 'more tags' : 'tag'} '),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            margin:
                                EdgeInsets.only(left: index == 0 ? 0.0 : 12.0),
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: ThemeColors.black40)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '${provider?.selectedTags[index]}',
                                    textAlign: TextAlign.center,
                                    style: ThemeText.sfSemiBoldFootnote
                                        .copyWith(color: ThemeColors.black80),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      provider.deleteSelectedTag =
                                          provider.selectedTags[index];
                                    },
                                    child: SvgPicture.asset(
                                        'images/clear_icon.svg'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  StreamBuilder<searchTags>(
                      stream: provider.streamTags,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data == searchTags.loading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (provider.listTags.isNotEmpty) {
                            return Card(
                              color: ThemeColors.black0,
                              elevation: 2.0,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      provider.listTags.length,
                                      (index) => InkWell(
                                            onTap: () {
                                              provider.addTags = provider
                                                  .listTags[index].tagName;
                                              provider.searchTagController
                                                  .clear();
                                              FocusScope.of(context).unfocus();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${provider?.listTags[index]?.tagName?.toLowerCase()}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    ThemeText.sfRegularHeadline,
                                              ),
                                            ),
                                          ))),
                            );
                          } else {
                            return Container();
                          }
                        }
                      }),
                  SizedBox(
                    height: provider.selectedTags.isNotEmpty ? 16.0 : 0.0,
                  ),
                ],
              );
            },
          ),
          Divider(
            thickness: 1.5,
            color: ThemeColors.black20,
          ),
          SizedBox(
            height: 12.0,
          )
        ],
      ),
    );
  }
}
