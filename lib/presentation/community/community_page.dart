import 'package:flutter/material.dart';
import 'package:localin/presentation/community/widget/community_card_widget.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../themes.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
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
        child: Container(
          margin: EdgeInsets.only(left: 10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Cari Komunitas'),
                ),
              ),
              Row(
                children: List.generate(4, (index) {
                  return QuickMenuCommunity(index: index);
                }),
              ),
              CommunityCardWidget(),
              CommunityBottomCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickMenuCommunity extends StatelessWidget {
  final int index;
  QuickMenuCommunity({this.index});
  final title = ['Semua', 'IT', 'Community', 'Seni'];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
            color: Themes.primaryBlue,
            borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title[index],
            style: kValueStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class CommunityBottomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RoundedClipper(),
      child: Container(
        color: Themes.primaryBlue,
        height: 350.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bangun Komunitas Kamu',
              style: kValueStyle.copyWith(fontSize: 14.0, color: Colors.white),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Sekarang Juga!',
              style: kValueStyle.copyWith(fontSize: 30.0, color: Colors.white),
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              elevation: 5.0,
              onPressed: () {},
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Text(
                'Buat Komunitas',
                style: kValueStyle.copyWith(
                    fontSize: 14.0, color: Themes.primaryBlue),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    Path path = Path()
      ..moveTo(0.0, height * 0.3)
      ..quadraticBezierTo(width * 0.5, 0.0, width, size.height * 0.3)
      ..lineTo(width, height)
      ..lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
