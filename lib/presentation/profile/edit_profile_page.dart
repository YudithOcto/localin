import 'package:flutter/material.dart';
import 'package:localin/components/bottom_company_information.dart';
import 'package:localin/components/social_button.dart';
import 'package:localin/presentation/profile/connect_dana_account_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/presentation/profile/profile_row_card.dart';
import 'package:localin/presentation/profile/row_connect_dana.dart';
import 'package:localin/provider/auth_provider.dart';
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
    var authState = Provider.of<AuthProvider>(context);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfileRowCard(
                isEditProfile: true,
              ),
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
                      child: Container(
                        height: 30.0,
                        child: TextFormField(
                          initialValue: authState.userModel.email.isNotEmpty
                              ? authState.userModel.email
                              : '',
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Display Name',
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Themes.primaryBlue)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Themes.primaryBlue))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              RowConnectDana(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(ConnectDanaAccountPage.routeName);
                },
              ),
              SocialLoginCard(),
              ShortBioCard(),
              RowSaveButton(),
              VerifyAccountCard(),
              BottomCompanyInformation(),
            ],
          ),
        ));
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
          color: Themes.primaryBlue,
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
          color: Themes.primaryBlue,
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
          border: Border.all(color: Themes.primaryBlue),
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: FractionalOffset.topLeft,
              child: TextFormField(
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
                side: BorderSide(color: Themes.primaryBlue),
                borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              'Back',
              style: kValueStyle.copyWith(
                  color: Themes.primaryBlue, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          RaisedButton(
            onPressed: () {},
            elevation: 5.0,
            color: Themes.primaryBlue,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Themes.primaryBlue),
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
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 80.0),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Themes.primaryBlue),
          borderRadius: BorderRadius.circular(10.0)),
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
              decoration: InputDecoration(
                  labelText: 'ID Card Number',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Themes.primaryBlue),
                      borderRadius: BorderRadius.circular(12.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Themes.primaryBlue),
                      borderRadius: BorderRadius.circular(12.0))),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: RaisedButton(
              onPressed: () {},
              elevation: 5.0,
              color: Themes.primaryBlue,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Themes.primaryBlue),
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
              onPressed: () {},
              elevation: 5.0,
              color: Themes.primaryBlue,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Themes.primaryBlue),
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
    );
  }
}
