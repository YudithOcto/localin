import 'package:flutter/material.dart';

import '../../themes.dart';

class ProfileRowCard extends StatelessWidget {
  final kTitleStyle = TextStyle(
      fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w500);

  final kValueStyle = TextStyle(
      fontSize: 14.0, color: Themes.black212121, fontWeight: FontWeight.w600);

  final Function onSettingPressed;
  final bool isEditProfile;
  ProfileRowCard({this.onSettingPressed, this.isEditProfile});

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
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 25.0,
                right: 140.0,
                child: Visibility(
                  visible: !isEditProfile,
                  child: InkWell(
                    onTap: onSettingPressed,
                    child: Icon(
                      Icons.settings,
                      color: Themes.primaryBlue,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                right: 0.0,
                bottom: -10.0,
                child: Visibility(
                  visible: !isEditProfile,
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
                ),
              ),
              Positioned(
                bottom: 25.0,
                left: 0.0,
                right: 0.0,
                child: Align(
                  alignment: FractionalOffset.center,
                  child: Visibility(
                    visible: isEditProfile,
                    child: Container(
                      width: 100.0,
                      decoration: BoxDecoration(
                          color: Themes.primaryBlue,
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        child: Text(
                          'Change',
                          textAlign: TextAlign.center,
                          style: kValueStyle.copyWith(
                              color: Colors.white,
                              fontSize: 12.0,
                              letterSpacing: -.5,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible: !isEditProfile,
          child: Container(
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
