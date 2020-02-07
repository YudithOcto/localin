import 'package:flutter/material.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';
import 'package:localin/presentation/profile/widgets/dana_active_row.dart';
import 'package:localin/presentation/profile/widgets/profile_page_row_card.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/profile/user_profile_detail_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';
import '../edit_profile_page.dart';
import 'row_connect_dana.dart';
import 'description_column.dart';

class HeaderProfile extends StatefulWidget {
  @override
  _HeaderProfileState createState() => _HeaderProfileState();
}

class _HeaderProfileState extends State<HeaderProfile> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      Provider.of<UserProfileProvider>(context, listen: false)
          .getUserDanaStatus();
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthProvider>(context);
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        ProfilePageRowCard(onSettingPressed: () {
          Navigator.of(context).pushNamed(EditProfilePage.routeName);
        }),
        StreamBuilder<DanaAccountDetail>(
          stream: provider.danaAccountStream,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (asyncSnapshot.hasError) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('An error occured'),
                    ],
                  ),
                );
              } else {
                if (asyncSnapshot.data == null ||
                    asyncSnapshot.data.maskDanaId == null) {
                  return RowConnectDana(
                    onPressed: () async {
                      if (authState.userModel.handphone != null &&
                          authState.userModel.handphone.isNotEmpty) {
                        final result =
                            await provider.authenticateUserDanaAccount(
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
                                        color: Themes.primaryBlue,
                                        onPressed: () => Navigator.of(context)
                                            .pop('success'),
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
                  );
                } else {
                  return DanaActiveRow(
                    detail: asyncSnapshot.data,
                    isNeedRefresh: (isNeedRefresh) {
                      if (isNeedRefresh) {
                        setState(() {
                          Provider.of<UserProfileProvider>(context,
                                  listen: false)
                              .getUserDanaStatus();
                        });
                      }
                    },
                  );
                }
              }
            }
          },
        ),
        authState?.userModel?.shortBio != null
            ? DescriptionColumn()
            : Container(),
        SizedBox(
          height: 20.0,
        ),
        Container(
          height: 1.0,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          color: Colors.black26,
        ),
      ],
    );
  }
}
