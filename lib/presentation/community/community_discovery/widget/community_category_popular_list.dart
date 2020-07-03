import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_only_radius.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_discover_subtitle_widget.dart';
import 'package:localin/presentation/community/provider/community_category_provider.dart';
import 'package:localin/presentation/shared_widgets/empty_community_with_custom_message.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityCategoryPopularList extends StatefulWidget {
  final String categoryId;
  CommunityCategoryPopularList({this.categoryId});
  @override
  _CommunityCategoryPopularListState createState() =>
      _CommunityCategoryPopularListState();
}

class _CommunityCategoryPopularListState
    extends State<CommunityCategoryPopularList> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<CommunityCategoryProvider>(context, listen: false)
          .getPopularCommunity(categoryId: widget.categoryId);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityCategoryProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<popularCommunityState>(
            stream: provider.streamPopular,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (provider.popularCommunity.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CommunityDiscoverSubtitleWidget(
                          svgAsset: 'images/star_orange.svg',
                          title: 'Popular Community',
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: ClampingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 10),
                          itemCount: provider.popularCommunity.length,
                          itemBuilder: (context, index) {
                            final item = provider.popularCommunity[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    CommunityDetailPage.routeName,
                                    arguments: {
                                      CommunityDetailPage.communityData: item,
                                    });
                              },
                              child: Card(
                                elevation: 2.0,
                                color: ThemeColors.black0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                margin: EdgeInsets.only(
                                    left: index == 0 ? 20.0 : 6.0),
                                child: Container(
                                  width: 239,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CustomImageOnlyRadius(
                                        imageUrl: '${item.logoUrl}',
                                        topLeft: 8.0,
                                        fit: BoxFit.cover,
                                        topRight: 8.0,
                                        width: 239.0,
                                        height: 135.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 16.0, 16.0, 4.0),
                                        child: Text(
                                          '${item.categoryName}',
                                          style: ThemeText.sfSemiBoldFootnote
                                              .copyWith(
                                                  color: ThemeColors.black80),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                            bottom: 8.0),
                                        child: Text(
                                          '${item.name}',
                                          maxLines: 2,
                                          style: ThemeText.rodinaTitle3,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                            bottom: 12.0),
                                        child: Text(
                                          '${item.totalMember} members',
                                          style: ThemeText.sfMediumBody
                                              .copyWith(
                                                  color: ThemeColors.black80),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return EmptyCommunityWithCustomMessage(
                    title: 'Popular Community not found',
                    message: 'No popular community for this category',
                  );
                }
              }
            });
      },
    );
  }
}
