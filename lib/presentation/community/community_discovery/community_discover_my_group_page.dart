import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_my_group_latest_post.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_my_group_other_communities.dart';
import 'package:localin/presentation/community/community_search/search_community_page.dart';
import 'package:localin/presentation/community/provider/discover/latest_post_mygroup_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityDiscoverMyGroupPage extends StatelessWidget {
  static const routeName = 'CommunityDiscvoerMyGroup';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LatestPostMyGroupProvider>(
      create: (_) => LatestPostMyGroupProvider(),
      child: CommunityMyGroupWidget(),
    );
  }
}

class CommunityMyGroupWidget extends StatefulWidget {
  @override
  _CommunityMyGroupWidgetState createState() => _CommunityMyGroupWidgetState();
}

class _CommunityMyGroupWidgetState extends State<CommunityMyGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: CustomAppBar(
        pageTitle: 'My Communities',
        appBar: AppBar(),
        flexSpace: SafeArea(
            child: InkWell(
          onTap: () async {
            await Navigator.of(context).pushNamed(SearchCommunity.routeName);
          },
          child: Container(
              alignment: FractionalOffset.centerRight,
              margin: EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset('images/search_grey.svg')),
        )),
      ),
      body: Consumer<LatestPostMyGroupProvider>(
        builder: (context, provider, child) {
          return StreamBuilder<myGroupState>(
              stream: provider.state,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: provider.latestPost.length +
                      2 +
                      provider.otherCommunity.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        margin: EdgeInsets.all(20.0),
                        child: Text(
                          'LATEST POST IN COMMUNITIES',
                          style: ThemeText.sfSemiBoldFootnote
                              .copyWith(color: ThemeColors.black80),
                        ),
                      );
                    } else if (index <= 3) {
                      return CommunityMyGroupLatestPost(
                        singlePost: provider.latestPost[index - 1],
                      );
                    } else if (index == 4) {
                      return Container(
                        margin: EdgeInsets.all(20.0),
                        child: Text(
                          'OTHER COMMUNITIES',
                          style: ThemeText.sfSemiBoldFootnote
                              .copyWith(color: ThemeColors.black80),
                        ),
                      );
                    } else {
                      //because list should be start from 0, so current index in here is 5 should
                      // subtracted by 5 then become 0. So it is not out of range
                      return CommunityMyGroupOtherCommunities(
                        communityDetail: provider.otherCommunity[index - 5],
                      );
                    }
                  },
                );
              });
        },
      ),
    );
  }
}
