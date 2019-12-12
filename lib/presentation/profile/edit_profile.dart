import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_row_card.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = '/editProfile';
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
        body: Column(
          children: <Widget>[
            ProfileRowCard(
              isEditProfile: true,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'E-mail',
                  ),
                  SizedBox(
                    width: 80.0,
                  ),
                  Text('mail@example.com')
                ],
              ),
            )
          ],
        ));
  }
}
