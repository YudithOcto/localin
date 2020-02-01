import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/presentation/home/widget/community_single_card.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';

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
    return FutureBuilder<CommunityDetailBaseResponse>(
        future: baseResponseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text(snapshot?.data?.error),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Komunitas di Sekitarmu',
                        style: kValueStyle.copyWith(fontSize: 24.0),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Consumer<HomeProvider>(
                      builder: (ctx, state, child) {
                        return Container(
                          height: Orientation.portrait ==
                                  MediaQuery.of(context).orientation
                              ? MediaQuery.of(context).size.height * 0.5
                              : MediaQuery.of(context).size.height * 0.9,
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
                    ),
                  ],
                ),
              );
            }
          }
        });
  }
}
