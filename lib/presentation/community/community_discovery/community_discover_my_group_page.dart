import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_heading_type.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_my_group_latest_post.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_other_row_widget.dart';
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
        onClickBackButton: () => Navigator.of(context).pop(),
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
                  itemCount: provider.communityType.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = provider.communityType[index];
                    if (item is CommunityHeadingType) {
                      return Container(
                        margin: EdgeInsets.all(20.0),
                        child: Text(
                          '${item.title}',
                          style: ThemeText.sfSemiBoldFootnote
                              .copyWith(color: ThemeColors.black80),
                        ),
                      );
                    } else if (item is CommunityComment) {
                      return CommunityMyGroupLatestPost(
                        singlePost: item,
                      );
                    } else if (item is CommunityDetail) {
                      return CommunityOtherRowWidget(
                        detail: item,
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              });
        },
      ),
    );
  }
}
