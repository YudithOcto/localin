import 'package:flutter/material.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

import '../../../../text_themes.dart';

class HotelBookingContactDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      width: double.maxFinite,
      padding: const EdgeInsets.only(
          top: 16.0, left: 20.0, right: 20.0, bottom: 22.0),
      child: Consumer<AuthProvider>(
        builder: (_, provider, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(provider.userModel.username,
                  style: ThemeText.rodinaHeadline),
              Text(
                '${provider.userModel.handphone} • ${provider.userModel.email}',
                style: ThemeText.sfSemiBoldFootnote
                    .copyWith(color: ThemeColors.black80),
              )
            ],
          );
        },
      ),
    );
  }
}
