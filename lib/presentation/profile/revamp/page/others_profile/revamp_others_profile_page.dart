import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/profile/revamp/page/others_profile/revamp_others_profile_header_widget.dart';
import 'package:localin/presentation/profile/revamp/provider/revamp_others_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../text_themes.dart';
import '../../../../../themes.dart';

class RevampOthersProfilePage extends StatelessWidget {
  static const routeName = '/otherProfilePage';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RevampOthersProvider>(
      create: (_) => RevampOthersProvider(),
      child: RevampOthersProfileContent(),
    );
  }
}

class RevampOthersProfileContent extends StatefulWidget {
  @override
  _RevampOthersProfileContentState createState() =>
      _RevampOthersProfileContentState();
}

class _RevampOthersProfileContentState
    extends State<RevampOthersProfileContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          RevampOthersProfileHeaderWidget(),
        ],
      ),
    );
  }
}
