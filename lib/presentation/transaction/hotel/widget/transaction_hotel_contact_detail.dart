import 'package:flutter/material.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';

import '../../../../themes.dart';

class TransactionHotelContactDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 24.0, bottom: 8.0, left: 20.0, right: 20.0),
          child: Subtitle(
            title: 'CONTACT DETAILS (FOR E-TICKET)',
          ),
        ),
        Container(
          width: double.maxFinite,
          color: ThemeColors.black0,
          margin: EdgeInsets.only(top: 4.0),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Consumer<AuthProvider>(
            builder: (_, provider, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${provider.userModel.username}',
                      style: ThemeText.rodinaHeadline),
                  SizedBox(height: 5.0),
                  Text(
                      '${provider.userModel.handphone} • ${provider.userModel.email}',
                      style: ThemeText.sfSemiBoldFootnote
                          .copyWith(color: ThemeColors.black80)),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
