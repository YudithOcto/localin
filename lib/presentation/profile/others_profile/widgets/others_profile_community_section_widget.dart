import 'package:flutter/material.dart';
import 'package:localin/components/shared_community_components/community_empty_page.dart';
import 'package:localin/components/shared_community_components/community_single_card.dart';
import 'package:localin/presentation/profile/provider/revamp_others_provider.dart';
import 'package:provider/provider.dart';

class OthersProfileCommunitySectionWidget extends StatefulWidget {
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
              .getCommunityList();
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
        SizedBox(
          height: 24.0,
        ),
        FutureBuilder(
          future: _loadCommunityFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null ||
                  (snapshot.hasData &&
                      snapshot.data.communityDetailList.isEmpty)) {
                return CommunityEmptyPage();
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
                          return CommunitySingleCard(
                              index: index, model: state.communityList[index]);
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
