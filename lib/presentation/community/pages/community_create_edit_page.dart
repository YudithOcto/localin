import 'package:flutter/material.dart';
import 'package:localin/presentation/community/widget/community_create_edit_form.dart';
import 'package:localin/presentation/community/widget/custom_rounded_header_page.dart';
import 'package:localin/provider/community/community_createedit_provider.dart';
import 'package:provider/provider.dart';

class CommunityCreateEditPage extends StatefulWidget {
  static const routeName = 'CommunityCreateEditPage';
  static const isUpdatePage = '/isUpdatePage';
  @override
  _CommunityCreateEditPageState createState() =>
      _CommunityCreateEditPageState();
}

class _CommunityCreateEditPageState extends State<CommunityCreateEditPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommunityCreateEditProvider>(
      create: (_) => CommunityCreateEditProvider(),
      child: Scaffold(
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
              CommunityCreateEditForm(),
            ],
          ),
        ),
      ),
    );
  }
}
