import 'package:flutter/material.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/profile/user_edit_profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class EditProfileRowCard extends StatelessWidget {
  final kTitleStyle = TextStyle(
      fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w500);

  final kValueStyle = TextStyle(
      fontSize: 14.0, color: Themes.black212121, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    void showDialogImagePicker(UserEditProfileProvider profileState) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Edit Profile Image'),
              content: Text('Choose your preference to change your image'),
              actions: <Widget>[
                RaisedButton(
                  color: Themes.primaryBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    var request = await profileState.openGallery(false);
                    if (request.isNotEmpty) {
                      print(request);
                    }
                  },
                  elevation: 5.0,
                  child: Text(
                    'Image Gallery',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  color: Themes.primaryBlue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    var request = await profileState.openCamera(false);
                    if (request.isEmpty) {
                      print(request);
                    }
                  },
                  elevation: 5.0,
                  child: Text(
                    'Camera',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                )
              ],
            );
          });
    }

    final height = MediaQuery.of(context).size.height * 0.2;
    var authState = Provider.of<AuthProvider>(context, listen: false);
    return Consumer<UserEditProfileProvider>(
      builder: (ctx, profileState, child) {
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
                    child: profileState.imageFile == null &&
                            authState.userModel.imageProfile.isNotEmpty
                        ? CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                NetworkImage(authState.userModel.imageProfile),
                          )
                        : profileState.imageFile != null
                            ? CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                    FileImage(profileState.imageFile),
                              )
                            : CircleAvatar(
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
                    left: 0.0,
                    right: 0.0,
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: InkWell(
                        onTap: () async {
                          showDialogImagePicker(profileState);
                        },
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
                  ),
                  Positioned(
                    right: 0.0,
                    top: 5.0,
                    child: InkWell(
                      onTap: () async {
                        var logout = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Logout'),
                                content:
                                    Text('Are you sure you want to log out?'),
                                actions: <Widget>[
                                  RaisedButton(
                                    elevation: 4.0,
                                    color: Themes.primaryBlue,
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
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
                            var result = await authState.signOutFacebook();
                            if (result == 'Success logout') {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginPage.routeName);
                            } else {
                              showErrorMessageDialog(context, result);
                            }
                          } else {
                            var result = await authState.signOutGoogle();
                            if (result.contains('Success logout')) {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginPage.routeName);
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
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
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
          ],
        );
      },
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
}
