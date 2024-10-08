import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/shared_community_components/community_empty_page.dart';
import 'package:localin/components/shared_community_components/community_single_card.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/presentation/community/community_discovery/community_discover_page.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';

import '../../../../themes.dart';

class RowCommunity extends StatefulWidget {
  @override
  _RowCommunityState createState() => _RowCommunityState();
}

class _RowCommunityState extends State<RowCommunity> {
  bool isInit = true;
  Future<CommunityDetailBaseResponse> baseResponseFuture;

  @override
  void didChangeDependencies() {
    if (isInit) {
      baseResponseFuture = Provider.of<HomeProvider>(context, listen: false)
          .getCommunityList('');
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SvgPicture.asset('images/star_orange.svg'),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Community around me',
                    textAlign: TextAlign.center,
                    style: ThemeText.sfSemiBoldHeadline,
                  )
                ],
              ),
              InkWell(
                onTap: () async {
                  final result = await Navigator.of(context)
                      .pushNamed(CommunityDiscoverPage.routeName);
                  if (result != null) {
                    /// refresh the page
                  }
                },
                child: Text(
                  'Discover',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfSemiBoldHeadline
                      .copyWith(color: ThemeColors.primaryBlue),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        FutureBuilder<CommunityDetailBaseResponse>(
            future: baseResponseFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.error != null ||
                    (snapshot.hasData &&
                        snapshot.data.communityDetailList.isEmpty)) {
                  return CommunityEmptyPage();
                } else {
                  return Consumer<HomeProvider>(
                    builder: (ctx, state, child) {
                      return Container(
                        height: 259.0,
                        margin: EdgeInsets.only(left: 20.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.communityDetail != null
                              ? state.communityDetail.length
                              : 0,
                          itemBuilder: (context, index) {
                            return CommunitySingleCard(
                                index: index,
                                model: state.communityDetail[index]);
                          },
                        ),
                      );
                    },
                  );
                }
              }
            }),
      ],
    );
  }
}
