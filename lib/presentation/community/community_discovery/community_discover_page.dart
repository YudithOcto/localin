import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/shared_community_components/community_empty_page.dart';
import 'package:localin/presentation/community/community_create/community_create_page.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_discover_subtitle_widget.dart';
import 'package:localin/presentation/community/community_search/search_community_page.dart';
import 'package:localin/presentation/community/provider/community_feed_provider.dart';
import 'package:localin/presentation/community/provider/community_nearby_provider.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_discover_category_widget.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_my_group_widget.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_nearby_widget.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class CommunityDiscoverPage extends StatelessWidget {
  static const routeName = 'CommunityDiscoverPage';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityFeedProvider>(
          create: (_) => CommunityFeedProvider(),
        ),
        ChangeNotifierProvider<CommunityNearbyProvider>(
          create: (_) => CommunityNearbyProvider(),
        )
      ],
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
  final _scrollController = ScrollController();
  Future getCommunityData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      Provider.of<CommunityNearbyProvider>(context)
          .getNearbyCommunity(isRefresh: true);
      _scrollController..addListener(_listener);
      getCommunityData =
          Provider.of<CommunityFeedProvider>(context, listen: false)
              .getDataFromApi();
      isInit = false;
    }
  }

  _listener() {
    if (_scrollController.offset >
        _scrollController.position.maxScrollExtent * 0.95) {
      Provider.of<CommunityNearbyProvider>(context)
          .getNearbyCommunity(isRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Community',
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
                  CommunityDiscoverSubtitleWidget(
                    svgAsset: 'images/star_orange.svg',
                    title: 'My Communities',
                  ),
                  InkWell(
                    onTap: () {
                      final auth =
                          Provider.of<AuthProvider>(context, listen: false);
                      if (auth.userModel.status == kUserStatusVerified) {
                        Navigator.of(context)
                            .pushNamed(CommunityCreatePage.routeName);
                      } else {
                        CustomDialog.showCustomDialogWithMultipleButton(context,
                            title: 'Create Community',
                            message:
                                'Your Account Has Not Been Verified, Please Verify Your Account',
                            cancelText: 'Close',
                            okText: 'Verified', okCallback: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(RevampUserVerificationPage.routeName);
                        });
                      }
                    },
                    child: Row(
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
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: getCommunityData,
              builder: (context, snapshot) {
                print(snapshot);
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
                        ],
                      );
                    },
                  );
                }
              },
            ),
            CommunityNearbyWidget(),
          ],
        ),
      ),
    );
  }
}
