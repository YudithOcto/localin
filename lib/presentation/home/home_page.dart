import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/presentation/error_page/page_404.dart';
import 'package:localin/presentation/home/widget/article_single_card.dart';
import 'package:localin/presentation/home/widget/circle_material_button.dart';
import 'package:localin/presentation/home/widget/community_single_card.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import '../../themes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderContentCard(),
            RowQuickMenu(),
            containerDivider(),
            RowCommunity(),
            Divider(
              color: Colors.black26,
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              margin: EdgeInsets.only(top: 5.0),
              child: Text(
                'Yang Terjadi Di Sekitarmu',
                style: kValueStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              children: List.generate(4, (index) {
                return ArticleSingleCard(index);
              }),
            ),
          ],
        ),
      ),
    );
  }

  containerDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
      color: Colors.black26,
      width: double.infinity,
      height: 1.0,
    );
  }
}

class HeaderContentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Image.asset(
            'images/static_map_image.png',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: -20.0,
          left: 20.0,
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                child: Icon(
                  Icons.person,
                  size: 20.0,
                ),
              ),
              SizedBox(width: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'John Thor',
                        style: kValueStyle.copyWith(fontSize: 18.0),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.verified_user,
                        color: Themes.primaryBlue,
                        size: 15.0,
                      )
                    ],
                  ),
                  Text(
                    'Mau ngapain hari ini',
                    style: kValueStyle.copyWith(
                        fontSize: 16.0, color: Colors.black54),
                  )
                ],
              )
            ],
          ),
        ),
        Positioned(
          bottom: -25.0,
          right: 20.0,
          child: FloatingActionButton(
            backgroundColor: Themes.red,
            onPressed: () {
              Navigator.of(context).pushNamed(Page404.routeName);
            },
            elevation: 5.0,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        )
      ],
    );
  }
}

class RowQuickMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: CircleMaterialButton(
              onPressed: () {},
              icon: Icons.hotel,
            ),
          ),
          Expanded(
            child: CircleMaterialButton(
              onPressed: () {},
              icon: Icons.confirmation_number,
            ),
          ),
          Expanded(
            child: CircleMaterialButton(
              onPressed: () {},
              icon: Icons.beach_access,
            ),
          ),
          Expanded(
            child: CircleMaterialButton(
              onPressed: () {},
              icon: Icons.restaurant,
            ),
          ),
          Expanded(
            child: CircleMaterialButton(
              onPressed: () {},
              icon: Icons.monetization_on,
            ),
          )
        ],
      ),
    );
  }
}

class RowCommunity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Komunitas di Sekitarmu',
            style: kValueStyle.copyWith(fontSize: 24.0),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            height: Orientation.portrait == MediaQuery.of(context).orientation
                ? MediaQuery.of(context).size.height * 0.5
                : MediaQuery.of(context).size.height * 0.9,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return CommunitySingleCard(index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
