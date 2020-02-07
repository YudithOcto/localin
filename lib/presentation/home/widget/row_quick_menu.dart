import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/hotel/booking_history_provider.dart';
import 'package:provider/provider.dart';

import 'circle_material_button.dart';

class RowQuickMenu extends StatelessWidget {
  final bool isHomePage;
  final Repository _repository = Repository();
  final Function onPressed;
  RowQuickMenu({this.isHomePage, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final homeState = Provider.of<HomeProvider>(context, listen: false);
    final historyState =
        Provider.of<BookingHistoryProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: FadeAnimation(
              delay: 0.1,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'Kamar',
                onPressed: () {
                  if (isHomePage) {
                    homeState.setRoomPage(true);
                  } else {
                    historyState.setRoomPage(true);
                  }
                },
                icon: Icons.hotel,
              ),
            ),
          ),
          Expanded(
            child: FadeAnimation(
              delay: 0.2,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'Event',
                onPressed: () {
                  Navigator.of(context).pushNamed(EmptyPage.routeName);
                  //Navigator.of(context).pushNamed(InputPhoneNumber.routeName);
                },
                icon: Icons.confirmation_number,
              ),
            ),
          ),
          Expanded(
            child: FadeAnimation(
              delay: 0.2,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'Atraksi',
                onPressed: () {
//                  Navigator.of(context)
//                      .pushNamed(PhoneVerificationPage.routeName);
                  Navigator.of(context).pushNamed(EmptyPage.routeName);
                },
                icon: Icons.beach_access,
              ),
            ),
          ),
          Expanded(
            child: FadeAnimation(
              delay: 0.3,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'Makan',
                onPressed: () async {
                  Navigator.of(context).pushNamed(EmptyPage.routeName);
                },
                icon: Icons.restaurant,
              ),
            ),
          ),
          Expanded(
            child: FadeAnimation(
              delay: 0.3,
              fadeDirection: FadeDirection.right,
              child: CircleMaterialButton(
                title: 'DANA',
                onPressed: () async {
                  final result = await _repository.getUserDanaStatus();
                  if (result != null && result.data != null) {
                    await Navigator.of(context)
                        .pushNamed(WebViewPage.routeName, arguments: {
                      WebViewPage.urlName: result.data.urlTopUp,
                    });
                  } else {
                    onPressed();
                  }
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
