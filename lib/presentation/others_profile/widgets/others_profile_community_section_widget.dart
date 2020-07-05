import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/shared_community_components/community_single_card.dart';
import 'package:localin/presentation/others_profile/provider/others_profile_community_provider.dart';
import 'package:provider/provider.dart';
import '../../../text_themes.dart';
import 'empty_other_user_community_widget.dart';

class OthersProfileCommunitySectionWidget extends StatefulWidget {
  final String userId;
  final String username;
  OthersProfileCommunitySectionWidget(
      {@required this.userId, @required this.username});
  @override
  _OthersProfileCommunitySectionWidgetState createState() =>
      _OthersProfileCommunitySectionWidgetState();
}

class _OthersProfileCommunitySectionWidgetState
    extends State<OthersProfileCommunitySectionWidget> {
  bool _isInit = true;
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadData();
      _scrollController..addListener(_listener);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _listener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      loadData(isRefresh: false);
    }
  }

  loadData({isRefresh = true}) {
    Provider.of<OthersProfileCommunityProvider>(context, listen: false)
        .getOtherCommunityList(
      userId: widget.userId,
      isRefresh: isRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OthersProfileCommunityProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<otherCommunityState>(
          stream: Provider.of<OthersProfileCommunityProvider>(context,
                  listen: false)
              .communityStreamData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                provider.pageRequest <= 1) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 14.0, left: 20.0, right: 20.0, bottom: 16.0),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset('images/star_orange.svg'),
                        SizedBox(width: 6.0),
                        Text(
                          '${widget.username ?? ''}\'s Community',
                          style: ThemeText.sfSemiBoldHeadline
                              .copyWith(letterSpacing: .5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 260.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      itemCount: provider.communityList.length + 1,
                      itemBuilder: (context, index) {
                        if (snapshot.data == otherCommunityState.empty) {
                          return EmptyOtherUserCommunityWidget(
                            username: widget.username,
                          );
                        } else if (index < provider.communityList.length) {
                          final item = provider.communityList[index];
                          return Container(
                            height: 260.0,
                            child: CommunitySingleCard(
                              index: index,
                              model: item,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
