import 'package:flutter/material.dart';
import 'package:localin/components/bottom_company_information.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';

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
    return SafeArea(
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
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return SingleCard(index);
          },
        ),
      ),
    );
  }
}

class HeaderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ProfileImageCard(),
        DanaActiveRow(),
        Visibility(
          visible: false,
          child: DanaInactiveRow(),
        ),
        DescriptionColumn(),
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

class ProfileImageCard extends StatelessWidget {
  final Function onPressed;
  ProfileImageCard({this.onPressed});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          height: height,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                left: 0.0,
                right: 0.0,
                top: 20.0,
                child: CircleAvatar(
                  radius: 50.0,
                  child: Icon(
                    Icons.person,
                    size: 50.0,
                  ),
                ),
              ),
              Positioned(
                bottom: 25.0,
                right: 140.0,
                child: Icon(
                  Icons.settings,
                  color: Themes.primaryBlue,
                ),
              ),
              Positioned(
                left: 20.0,
                right: 0.0,
                bottom: -10.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Jhon Thor',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.verified_user,
                      size: 20.0,
                      color: Themes.primaryBlue,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
          height: 55.0,
          decoration: BoxDecoration(
              border: Border.all(color: Themes.primaryBlue),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              gridColumnDetail('Posts', '3959'),
              gridColumnDetail('Views', '8k'),
              gridColumnDetail('Points', '443'),
            ],
          ),
        ),
      ],
    );
  }

  Widget gridColumnDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: kValueStyle,
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            title,
            style: kTitleStyle,
          ),
        ],
      ),
    );
  }
}

class DanaActiveRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'images/dana_logo.png',
                scale: 7.0,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Saldo',
                style: kTitleStyle,
              )
            ],
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Themes.primaryBlue),
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
              child: Text(
                'AKTIF',
                style: kValueStyle.copyWith(
                    color: Themes.primaryBlue,
                    letterSpacing: -.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '62********9123',
                  style: kValueStyle,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Rp 21.500',
                  style: kValueStyle.copyWith(color: Themes.primaryBlue),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DanaInactiveRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/dana_logo.png',
          scale: 9.0,
        ),
        SizedBox(
          width: 8.0,
        ),
        Container(
          decoration: BoxDecoration(
              color: Themes.primaryBlue,
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              'CONNECT',
              style: kValueStyle.copyWith(
                  color: Colors.white,
                  fontSize: 12.0,
                  letterSpacing: -.5,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

class DescriptionColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            Constants.kRandomWords,
            textAlign: TextAlign.center,
            style: kValueStyle.copyWith(fontSize: 12.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageIcon(
                ExactAssetImage('images/ic_fb_small.png'),
                color: Themes.primaryBlue,
                size: 30.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              ImageIcon(
                ExactAssetImage('images/ic_google.png'),
                size: 30.0,
                color: Themes.primaryBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SingleCard extends StatelessWidget {
  final int index;
  SingleCard(this.index);

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return HeaderProfile();
    } else if (index == 4) {
      return BottomCompanyInformation();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'images/cafe.jpg',
                fit: BoxFit.fill,
                width: 150.0,
                height: 90.0,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'FlyOver Gaplek di Bangun Akhir Agustus',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kValueStyle.copyWith(fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Themes.orange,
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4.0),
                          child: Text(
                            'Opinion',
                            style: kValueStyle.copyWith(
                                color: Colors.white,
                                fontSize: 10.0,
                                letterSpacing: -.5,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '27 Agustus 2019',
                        style: kValueStyle.copyWith(
                            fontSize: 10.0, color: Colors.black54),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}
