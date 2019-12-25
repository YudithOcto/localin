import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/presentation/home/widget/article_single_card.dart';
import 'package:localin/presentation/home/widget/row_quick_menu.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'community_single_card.dart';

class HomeContentDefault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay: 0.5,
      fadeDirection: FadeDirection.bottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RowQuickMenu(),
          containerDivider(),
          RowCommunity(),
          Divider(
            color: Colors.black26,
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            margin: EdgeInsets.only(top: 5.0),
            child: Text(
              'Yang Terjadi Di Sekitarmu',
              style: kValueStyle.copyWith(fontSize: 24.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Column(
            children: List.generate(4, (index) {
              return ArticleSingleCard(index);
            }),
          ),
        ],
      ),
    );
  }

  containerDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
      color: Colors.black26,
      width: double.infinity,
      height: 1.0,
    );
  }
}

class RowCommunity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<HomeProvider>(context, listen: false);
    return FutureBuilder<CommunityDetailBaseResponse>(
        future: state.getArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data.error != null) {
              return Center(
                child: Text(snapshot.data.error),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Komunitas di Sekitarmu',
                      style: kValueStyle.copyWith(fontSize: 24.0),
                    ),
                    SizedBox(
                      height: 8.0,
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
