import 'package:flutter/material.dart';
import 'package:localin/presentation/community/widget/community_event_form_card.dart';
import 'package:localin/presentation/community/widget/custom_rounded_header_page.dart';

class CommunityCreateEventPage extends StatefulWidget {
  static const routeName = '/communityCreateEventPage';
  @override
  _CommunityCreateEventPageState createState() =>
      _CommunityCreateEventPageState();
}

class _CommunityCreateEventPageState extends State<CommunityCreateEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5.0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Image.asset(
          'images/app_bar_logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
          height: 50.0,
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            CustomRoundedHeaderPage(
              bigTitle: 'Buat Acara',
              subtitleFirst:
                  'Kembangkan dan raih banyak relasi ke banyak orang dengan mengadakan Acara/Event di ',
              boldSubtitle: 'Localin.',
            ),
            CommunityEventFormCard(),
          ],
        ),
      ),
    );
  }
}
