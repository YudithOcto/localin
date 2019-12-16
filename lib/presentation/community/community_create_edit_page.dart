import 'package:flutter/material.dart';
import 'package:localin/presentation/community/widget/community_create_edit_form.dart';
import 'package:localin/presentation/community/widget/custom_rounded_header_page.dart';

class CommunityCreateEditPage extends StatefulWidget {
  static const routeName = '/communityCreateEdit';
  static const isUpdatePage = '/isUpdatePage';
  @override
  _CommunityCreateEditPageState createState() =>
      _CommunityCreateEditPageState();
}

class _CommunityCreateEditPageState extends State<CommunityCreateEditPage> {
  bool isUpdatePage = false;
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    bool isUpdatePage = routeArgs[CommunityCreateEditPage.isUpdatePage];
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
        child: Column(
          children: <Widget>[
            CustomRoundedHeaderPage(
              bigTitle: 'Buat Komunitas',
              subtitleFirst:
                  'hubungkan bisnis, diri anda sendiri, atau gerakan ke komunitas orang di seluruh'
                  'dunia dengan ',
              subtitleSecond:
                  ' Untuk memulai, tentukan nama, lalu pilih kategori halaman.',
              boldSubtitle: 'Localin.',
            ),
            CommunityCreateEditForm(
              isUpdatePage: isUpdatePage,
            ),
          ],
        ),
      ),
    );
  }
}
