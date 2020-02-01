import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class ProfilePageRowCard extends StatelessWidget {
  final kTitleStyle = TextStyle(
      fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w500);

  final kValueStyle = TextStyle(
      fontSize: 14.0, color: Themes.black212121, fontWeight: FontWeight.w600);

  final Function onSettingPressed;

  ProfilePageRowCard({this.onSettingPressed});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.2;
    var authState = Provider.of<AuthProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          height: height,
          child: Stack(
            overflow: Overflow.visible,
            alignment: FractionalOffset.center,
            children: <Widget>[
              Positioned(
                top: 20.0,
                child: CachedNetworkImage(
                  imageUrl: authState?.userModel?.imageProfile,
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                      radius: 50.0,
                      backgroundImage: imageProvider,
                    );
                  },
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 50.0,
                  ),
                  errorWidget: (context, url, child) => CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 25.0,
                right: 140.0,
                child: InkWell(
                  onTap: onSettingPressed,
                  child: Icon(
                    Icons.settings,
                    color: Themes.primaryBlue,
                  ),
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
                      '${authState.userModel.username.isNotEmpty ? authState.userModel.username : ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    authState.userModel.status == 'verified_identitas'
                        ? Icon(
                            Icons.verified_user,
                            size: 20.0,
                            color: Themes.primaryBlue,
                          )
                        : Container()
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                top: 5.0,
                child: InkWell(
                  onTap: () async {
                    final logout = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Logout'),
                            content: Text('Are you sure you want to log out?'),
                            actions: <Widget>[
                              RaisedButton(
                                elevation: 4.0,
                                color: Themes.primaryBlue,
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                              RaisedButton(
                                elevation: 4.0,
                                color: Colors.grey,
                                onPressed: () {
                                  Navigator.of(context).pop('success');
                                },
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        });
                    if (logout != null && logout == 'success') {
                      if (authState.userModel.source == 'facebook.com') {
                        final result = await authState.signOutFacebook();
                        if (result == 'Success logout') {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              LoginPage.routeName,
                              (Route<dynamic> route) => false);
                        } else {
                          showErrorMessageDialog(context, result);
                        }
                      } else {
                        final result = await authState.signOutGoogle();
                        if (result.contains('Success logout')) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              LoginPage.routeName,
                              (Route<dynamic> route) => false);
                        } else {
                          showErrorMessageDialog(context, result);
                        }
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Themes.primaryBlue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.power_settings_new,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            'LOGOUT',
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
          decoration: BoxDecoration(
              border: Border.all(color: Themes.primaryBlue),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              gridColumnDetail('Posts', '0'),
              gridColumnDetail('Views', '0'),
              gridColumnDetail('Points', '0'),
            ],
          ),
        ),
      ],
    );
  }

  void showErrorMessageDialog(BuildContext context, String error) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login'),
            content: Text(error),
            actions: <Widget>[
              RaisedButton(
                elevation: 5.0,
                color: Themes.primaryBlue,
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              )
            ],
          );
        });
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
