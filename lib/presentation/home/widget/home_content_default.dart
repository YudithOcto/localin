import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/presentation/home/widget/article_single_card.dart';
import 'package:localin/presentation/home/widget/row_quick_menu.dart';
import 'package:localin/presentation/profile/profile_page.dart';
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
          Container(
            height: Orientation.portrait == MediaQuery.of(context).orientation
                ? MediaQuery.of(context).size.height * 0.5
                : MediaQuery.of(context).size.height * 0.9,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return CommunitySingleCard(index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
