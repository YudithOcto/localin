import 'package:flutter/material.dart';
import 'package:localin/components/bottom_company_information.dart';
import 'package:localin/components/social_button.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/presentation/profile/widgets/edit_profile_row_card.dart';
import 'package:localin/presentation/profile/widgets/row_connect_dana.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/profile/user_edit_profile_provider.dart';
import 'package:localin/provider/profile/user_profile_detail_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../themes.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = '/editProfile';
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthProvider>(context, listen: false);
    return ChangeNotifierProvider<UserEditProfileProvider>(
      create: (_) => UserEditProfileProvider(model: authState.userModel),
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
          body: ScrollContentPage()),
    );
  }
}

class ScrollContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthProvider>(context);
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EditProfileRowCard(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'E-mail',
                        style: Constants.kValueStyle,
                      ),
                      SizedBox(
                        width: 80.0,
                      ),
                      Text(
                        '${authState.userModel.email.isNotEmpty ? authState.userModel.email : ''}',
                        style: Constants.kValueStyle,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Display',
                        style: Constants.kValueStyle,
                      ),
                      SizedBox(
                        width: 70.0,
                      ),
                      Expanded(
                        child: Consumer<UserEditProfileProvider>(
                          builder: (ctx, pState, child) {
                            return Container(
                              height: 30.0,
                              child: TextFormField(
                                controller: pState.displayNameController,
                                style: TextStyle(
                                    fontSize: 11.0, color: Colors.black),
                                decoration: InputDecoration(
                                    labelText: 'Display Name',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ThemeColors.primaryBlue)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ThemeColors.primaryBlue))),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                RowConnectDana(
                  onPressed: () async {
                    if (authState.userModel.handphone != null &&
                        authState.userModel.handphone.isNotEmpty) {
                      final result =
                          await Provider.of<UserProfileProvider>(context)
                              .authenticateUserDanaAccount(
                                  authState.userModel.handphone);
                      if (result.urlRedirect.isNotEmpty && !result.error) {
                        final response = await Navigator.of(context)
                            .pushNamed(WebViewPage.routeName, arguments: {
                          WebViewPage.urlName: result.urlRedirect
                        });
                        if (response != null && response == 'success') {
                          final dialogResult = await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('DANA'),
                                  content: Text(
                                    'Connect to dana success',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      color: ThemeColors.primaryBlue,
                                      onPressed: () =>
                                          Navigator.of(context).pop('success'),
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                );
                              });

                          if (dialogResult == 'success') {
                            Provider.of<UserProfileProvider>(context)
                                .getUserDanaStatus();
                          }
                        }
                      }
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('No Phone number on your account'),
                        duration: Duration(milliseconds: 1500),
                      ));
                    }
                  },
                ),
                //SocialLoginCard(),
                ShortBioCard(),
                RowSaveButton(),
                VerifyAccountCard(),
                BottomCompanyInformation(),
              ],
            ),
          ),
          Center(
            child: Consumer<UserEditProfileProvider>(
              builder: (ctx, state, child) {
                return state.progress != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            '${state.progress}',
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.white),
                          ),
                        ],
                      )
                    : Container();
              },
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) {
    return Provider.of<UserEditProfileProvider>(context) != null &&
            Provider.of<UserEditProfileProvider>(context).isProfileNeedUpdate
        ? showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Profile save'),
              content: new Text(
                  'You have changed that not yet saved. Do you want to save first?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Provider.of<UserEditProfileProvider>(context)
                        .clearChangedFile();
                    Navigator.of(context).pop(true);
                  },
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )
        : Navigator.of(context).pop();
  }
}

class SocialLoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 25.0,
        ),
        SocialButton(
          onPressed: () {},
          color: ThemeColors.primaryBlue,
          textColor: Colors.white,
          title: 'FACEBOOK',
          height: 40.0,
          imageAsset: 'images/ic_fb_small.png',
        ),
        SizedBox(
          height: 10.0,
        ),
        SocialButton(
          onPressed: () {},
          color: ThemeColors.primaryBlue,
          textColor: Colors.white,
          height: 40.0,
          title: 'GOOGLE',
          imageAsset: 'images/ic_google.png',
        ),
      ],
    );
  }
}

class ShortBioCard extends StatefulWidget {
  @override
  _ShortBioCardState createState() => _ShortBioCardState();
}

class _ShortBioCardState extends State<ShortBioCard> {
  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
      height: 200.0,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.primaryBlue),
          borderRadius: BorderRadius.circular(10.0)),
      child: Consumer<UserEditProfileProvider>(
        builder: (ctx, state, child) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: FractionalOffset.topLeft,
                  child: TextFormField(
                    controller: state.shortBioController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Short Bio'),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: checkbox(
                      'Yes, I want to received updates and announcements',
                      checkBoxValue),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget checkbox(String title, bool boolValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            setState(() {
              checkBoxValue = value;
            });
          },
        ),
        Expanded(child: Text(title)),
      ],
    );
  }
}

class RowSaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<UserEditProfileProvider>(context);
    return Container(
      margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            onPressed: () {},
            elevation: 5.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: ThemeColors.primaryBlue),
                borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              'Back',
              style: kValueStyle.copyWith(
                  color: ThemeColors.primaryBlue, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          RaisedButton(
            onPressed: () async {
              var progressValue = await state.updateProfileData();
              if (progressValue == '100%') {
                final response = await state.updateNewProfileData();
                if (response != null) {
                  Provider.of<AuthProvider>(context).setUserModel(response);
                  Navigator.of(context).pop();
                }
              }
            },
            elevation: 5.0,
            color: ThemeColors.primaryBlue,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: ThemeColors.primaryBlue),
                borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              'Save',
              style: kValueStyle.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class VerifyAccountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<UserEditProfileProvider>(context);
    return Visibility(
      visible: Provider.of<AuthProvider>(context).userModel.status !=
          'verified_identitas',
      child: Container(
        margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 80.0),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: ThemeColors.primaryBlue),
            borderRadius: BorderRadius.circular(10.0)),
        child: Form(
          key: state.formKey,
          autovalidate: state.autoValidate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  'Verify your account to get points',
                  style: kValueStyle.copyWith(fontSize: 16.0),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50.0),
                width: double.infinity,
                height: 40.0,
                child: TextFormField(
                  controller: state.idCardController,
                  validator: (value) =>
                      value.isEmpty ? 'Id Card Number required' : null,
                  decoration: InputDecoration(
                      labelText: 'ID Card Number',
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeColors.primaryBlue),
                          borderRadius: BorderRadius.circular(12.0)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeColors.primaryBlue),
                          borderRadius: BorderRadius.circular(12.0))),
                ),
              ),
              state.idFile != null
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0),
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            border: Border.all(color: ThemeColors.primaryBlue)),
                        child: Image.file(state.idFile),
                      ),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                child: RaisedButton(
                  onPressed: () {
                    showDialogImagePicker(context, state);
                  },
                  elevation: 5.0,
                  color: ThemeColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: ThemeColors.primaryBlue),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Upload Your ID',
                        style: kValueStyle.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.file_upload,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 30.0,
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(top: 20.0, bottom: 10.0, right: 10.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (state.validateInput()) {
                      var progress = await state.verifyAccount();
                      if (progress == '100%') {
                        var response = await state.updateNewProfileData();
                        if (response != null) {
                          Provider.of<AuthProvider>(context)
                              .setUserModel(response);
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  },
                  elevation: 5.0,
                  color: ThemeColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: ThemeColors.primaryBlue),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    'Submit',
                    style: kValueStyle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDialogImagePicker(
      BuildContext context, UserEditProfileProvider profileState) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Verification Account'),
            content: Text('Upload your ID'),
            actions: <Widget>[
              RaisedButton(
                color: ThemeColors.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var request = await profileState.openGallery(true);
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
                color: ThemeColors.primaryBlue,
                onPressed: () async {
                  Navigator.of(context).pop();
                  var request = await profileState.openCamera(true);
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
}
