import 'package:flutter/material.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';
import 'package:localin/presentation/profile/widgets/dana_active_row.dart';
import 'package:localin/presentation/profile/widgets/profile_page_row_card.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/profile/user_profile_detail_provider.dart';
import 'package:provider/provider.dart';

import 'connect_dana_account_page.dart';
import '../edit_profile_page.dart';
import 'row_connect_dana.dart';
import 'description_column.dart';

class HeaderProfile extends StatefulWidget {
  @override
  _HeaderProfileState createState() => _HeaderProfileState();
}

class _HeaderProfileState extends State<HeaderProfile> {
  @override
  void initState() {
    Provider.of<UserProfileProvider>(context, listen: false)
        .getUserDanaStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthProvider>(context);
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        ProfilePageRowCard(onSettingPressed: () {
          Navigator.of(context).pushNamed(EditProfilePage.routeName);
        }),
        StreamBuilder<DanaAccountDetail>(
          stream: provider.danaAccountStream,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (asyncSnapshot.hasError) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('An error occured'),
                    ],
                  ),
                );
              } else {
                if (asyncSnapshot.data == null ||
                    asyncSnapshot.data.maskDanaId == null) {
                  return RowConnectDana(
                    onPressed: () async {
                      var result = await Navigator.of(context)
                          .pushNamed(ConnectDanaAccountPage.routeName);
                      if (result != null && result == 'success') {
                        Provider.of<UserProfileProvider>(context)
                            .getUserDanaStatus();
                      }
                    },
                  );
                } else {
                  return DanaActiveRow(detail: asyncSnapshot.data);
                }
              }
            }
          },
        ),
        authState?.userModel?.shortBio != null
            ? DescriptionColumn()
            : Container(),
        SizedBox(
          height: 20.0,
        ),
        Container(
          height: 1.0,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          color: Colors.black26,
        ),
      ],
    );
  }
}
