import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/shared_community_components/community_single_card.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/presentation/others_profile/provider/revamp_others_provider.dart';
import 'package:localin/themes.dart';
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
  Future _loadCommunityFuture;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _loadCommunityFuture =
          Provider.of<RevampOthersProvider>(context, listen: false)
              .getOtherCommunityList(widget.userId);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        FutureBuilder<CommunityDetailBaseResponse>(
          future: _loadCommunityFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null ||
                  (snapshot.hasData &&
                      snapshot.data.communityDetailList.isEmpty)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SvgPicture.asset('images/star_orange.svg'),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                '${widget.username}\'s Community',
                                style: ThemeText.sfSemiBoldHeadline
                                    .copyWith(letterSpacing: .5),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    EmptyOtherUserCommunityWidget(
                      username: widget.username,
                    ),
                  ],
                );
              } else {
                return Consumer<RevampOthersProvider>(
                  builder: (ctx, state, child) {
                    return Container(
                      height: 259.0,
                      margin: EdgeInsets.only(left: 20.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.communityList != null
                            ? state.communityList.length
                            : 0,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                          'images/star_orange.svg'),
                                      SizedBox(
                                        width: 6.0,
                                      ),
                                      Text(
                                        '1 Community',
                                        style: ThemeText.sfSemiBoldHeadline
                                            .copyWith(letterSpacing: .5),
                                      )
                                    ],
                                  ),
                                  Text(
                                    'See All (${state.communityList.length})',
                                    style: ThemeText.sfMediumHeadline.copyWith(
                                        color: ThemeColors.primaryBlue),
                                  )
                                ],
                              ),
                              CommunitySingleCard(
                                  index: index,
                                  model: state.communityList[index]),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ],
    );
  }
}
