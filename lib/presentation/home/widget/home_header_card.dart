import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/presentation/article/pages/create_article_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class HomeHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthProvider>(context);
    return Stack(
      fit: StackFit.loose,
      overflow: Overflow.visible,
      children: <Widget>[
        InkWell(
          onTap: () {
            //Navigator.of(context).pushNamed(SuccessBookingPage.routeName);
            //Navigator.of(context).pushNamed(BookingDetailPage.routeName);
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
          child: FadeAnimation(
            fadeDirection: FadeDirection.top,
            delay: 0.8,
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
                            NetworkImage('${user.userModel.imageProfile}'),
                      ),
                SizedBox(width: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '${user?.userModel?.username ?? ''}',
                          style: kValueStyle.copyWith(fontSize: 18.0),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        user?.userModel?.status == 'verified_identitas'
                            ? Icon(
                                Icons.verified_user,
                                color: Themes.primaryBlue,
                                size: 15.0,
                              )
                            : Container(),
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
        ),
        Positioned(
          bottom: -25.0,
          right: 20.0,
          child: FloatingActionButton(
            backgroundColor: Themes.red,
            onPressed: () {
              Navigator.of(context).pushNamed(CreateArticlePage.routeName);
            },
            elevation: 2.0,
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
