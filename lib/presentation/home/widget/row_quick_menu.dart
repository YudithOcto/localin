import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/presentation/booking/room_detail_page.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';

import 'circle_material_button.dart';

class RowQuickMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<HomeProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: FadeAnimation(
              delay: 0.2,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'Kamar',
                onPressed: () {
                  state.setRoomPage(true);
                },
                icon: Icons.hotel,
              ),
            ),
          ),
          Expanded(
            child: FadeAnimation(
              delay: 0.3,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'Event',
                onPressed: () {
                  Navigator.of(context).pushNamed(EmptyPage.routeName);
                },
                icon: Icons.confirmation_number,
              ),
            ),
          ),
          Expanded(
            child: FadeAnimation(
              delay: 0.4,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'Atraksi',
                onPressed: () {
                  Navigator.of(context).pushNamed(EmptyPage.routeName);
                },
                icon: Icons.beach_access,
              ),
            ),
          ),
          Expanded(
            child: FadeAnimation(
              delay: 0.5,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'Makan',
                onPressed: () {
                  Navigator.of(context).pushNamed(EmptyPage.routeName);
                },
                icon: Icons.restaurant,
              ),
            ),
          ),
          Expanded(
            child: FadeAnimation(
              delay: 0.6,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'DANA',
                onPressed: () {
                  Navigator.of(context).pushNamed(EmptyPage.routeName);
                },
                imageAsset: 'images/quick_dana_logo.png',
              ),
            ),
          )
        ],
      ),
    );
  }
}
