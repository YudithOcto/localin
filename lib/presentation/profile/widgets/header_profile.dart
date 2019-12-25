import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/widgets/profile_page_row_card.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import 'connect_dana_account_page.dart';
import '../edit_profile_page.dart';
import 'row_connect_dana.dart';
import 'description_column.dart';

class HeaderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthProvider>(context);
    return Column(
      children: <Widget>[
        ProfilePageRowCard(onSettingPressed: () {
          Navigator.of(context).pushNamed(EditProfilePage.routeName);
        }),
        RowConnectDana(
          onPressed: () {
            Navigator.of(context).pushNamed(ConnectDanaAccountPage.routeName);
          },
        ),
        authState?.userModel?.shortBio != null
            ? DescriptionColumn()
            : Container(),
        SizedBox(
          height: 40.0,
        ),
        Container(
          height: 1.0,
          width: double.infinity,
          color: Colors.black26,
        ),
      ],
    );
  }
}
