import 'package:flutter/material.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class RowUserLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    return Padding(
      padding:
          EdgeInsets.only(top: 20.0, bottom: 12.0, left: 20.0, right: 20.0),
      child: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hi, ${provider?.userModel?.username}',
                style: ThemeText.rodinaTitle2
                    .copyWith(color: ThemeColors.brandBlack),
              ),
              Text(
                '${locationProvider.address}',
                style:
                    ThemeText.sfMediumBody.copyWith(color: ThemeColors.black80),
              ),
            ],
          );
        },
      ),
    );
  }
}
