import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/widgets/single_card.dart';
import 'package:localin/themes.dart';

const kTitleStyle = TextStyle(
    fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w500);

const kValueStyle = TextStyle(
    fontSize: 14.0, color: Themes.black212121, fontWeight: FontWeight.w600);

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return SingleCard(index);
        },
      ),
    );
  }
}
