import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/shared_community_components/community_empty_page.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_other_row_widget.dart';
import 'package:localin/presentation/community/provider/community_nearby_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';

class CommunityNearbyWidget extends StatelessWidget {
  CommunityNearbyWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Row(
            children: <Widget>[
              SvgPicture.asset('images/star_orange.svg'),
              SizedBox(
                width: 5.67,
              ),
              Text(
                'Community around me',
                style: ThemeText.sfSemiBoldHeadline,
              )
            ],
          ),
        ),
        Consumer<CommunityNearbyProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<communityNearbyState>(
                stream: provider.communityStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      provider.offset <= 1) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: provider.communityNearbyList.length + 1,
                    itemBuilder: (context, index) {
                      if (provider.communityNearbyList.isEmpty &&
                          provider.offset <= 2) {
                        return CommunityEmptyPage();
                      } else if (index < provider.communityNearbyList.length) {
                        return CommunityOtherRowWidget(
                            detail: provider.communityNearbyList[index]);
                      } else if (provider.canLoadMore) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                });
          },
        )
      ],
    );
  }
}
