import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/presentation/booking/booking_detail_page.dart';
import 'package:localin/presentation/home/widget/home_content_default.dart';
import 'package:localin/presentation/home/widget/home_content_search_hotel.dart';
import 'package:localin/presentation/home/widget/search_form_widget.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import '../../themes.dart';

class HomePage extends StatefulWidget {
  final Map user;
  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearchPage = false;
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
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderContentCard(
              user: widget.user,
              onPressed: () {
                setState(() {
                  isSearchPage = !isSearchPage;
                });
              },
            ),
            isSearchPage ? SearchHotelContent() : HomeContentDefault(),
          ],
        ),
      ),
    );
  }
}

class SearchHotelContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchFormWidget(),
        Container(
          padding: EdgeInsets.only(bottom: 70.0),
          child: Column(
            children: List.generate(5, (index) {
              return FadeAnimation(
                delay: 0.5,
                fadeDirection: FadeDirection.bottom,
                child: HomeContentSearchHotel(
                  index: index,
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}

class HeaderContentCard extends StatelessWidget {
  final Function onPressed;
  final Map user;

  HeaderContentCard({this.onPressed, this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      overflow: Overflow.visible,
      children: <Widget>[
        InkWell(
          onTap: () {
            //Navigator.of(context).pushNamed(SuccessBookingPage.routeName);
            Navigator.of(context).pushNamed(BookingDetailPage.routeName);
          },
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              'images/static_map_image.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          bottom: -20.0,
          left: 20.0,
          child: Row(
            children: <Widget>[
              user == null
                  ? CircleAvatar(
                      radius: 20.0,
                      child: Icon(
                        Icons.person,
                        size: 20.0,
                      ),
                    )
                  : CircleAvatar(
                      radius: 25.0,
                      backgroundImage:
                          NetworkImage('${user['picture']['data']['url']}'),
                    ),
              SizedBox(width: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        user['name'],
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
              onPressed();
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
