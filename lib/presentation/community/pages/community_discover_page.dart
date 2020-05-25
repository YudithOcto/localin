import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/shared_community_components/community_empty_page.dart';
import 'package:localin/presentation/community/provider/community_feed_provider.dart';
import 'package:localin/presentation/community/widgets/community_discover_category_widget.dart';
import 'package:localin/presentation/community/widgets/community_my_group_widget.dart';
import 'package:localin/presentation/community/widgets/community_nearby_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityDiscoverPage extends StatefulWidget {
  static const routeName = 'CommunityDiscoverPage';
  @override
  _CommunityDiscoverPageState createState() => _CommunityDiscoverPageState();
}

class _CommunityDiscoverPageState extends State<CommunityDiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommunityFeedProvider>(
      create: (_) => CommunityFeedProvider(),
      child: ScrollContent(),
    );
  }
}

class ScrollContent extends StatefulWidget {
  @override
  _ScrollContentState createState() => _ScrollContentState();
}

class _ScrollContentState extends State<ScrollContent> {
  bool isInit = true;
  Future communityFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      communityFuture =
          Provider.of<CommunityFeedProvider>(context).getCommunityData();
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Community',
        appBar: AppBar(),
        flexSpace: SafeArea(
            child: Container(
                alignment: FractionalOffset.centerRight,
                margin: EdgeInsets.only(right: 20.0),
                child: SvgPicture.asset('images/search_grey.svg'))),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SvgPicture.asset('images/star_orange.svg'),
                      SizedBox(
                        width: 5.67,
                      ),
                      Text(
                        'My Group',
                        style: ThemeText.sfSemiBoldHeadline,
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Create',
                        style: ThemeText.sfSemiBoldBody
                            .copyWith(color: ThemeColors.primaryBlue),
                      ),
                      SizedBox(
                        width: 5.67,
                      ),
                      SvgPicture.asset('images/plus_icon.svg'),
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: communityFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Consumer<CommunityFeedProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          provider.userCommunityList.isNotEmpty
                              ? CommunityMyGroupWidget(
                                  userCommunityDetail:
                                      provider.userCommunityList,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: CommunityEmptyPage(),
                                ),
                          Visibility(
                            visible: provider.communityCategoryList.isNotEmpty,
                            child: CommunityDiscoverCategoryWidget(
                              communityCategoryList:
                                  provider.communityCategoryList,
                            ),
                          ),
                          CommunityNearbyWidget(
                            communityList: provider.communityNearbyList,
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
