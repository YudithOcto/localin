import 'package:flutter/material.dart';
import 'package:localin/components/bottom_company_information.dart';
import 'package:localin/presentation/profile/widgets/other_header_profile.dart';

class OtherProfilePage extends StatefulWidget {
  static const routeName = '/otherUserProfile';
  static const profileId = '/profileId';
  @override
  _OtherProfilePageState createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String profileId = routeArgs[OtherProfilePage.profileId];
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
                child: OtherHeaderProfile(
              profileId: profileId,
            )),
            BottomCompanyInformation(),
          ],
        ),
      ),
    );
  }
}
