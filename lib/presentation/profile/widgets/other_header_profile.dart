import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_model.dart';

import '../../../themes.dart';
import '../profile_page.dart';
import 'description_column.dart';

class OtherHeaderProfile extends StatefulWidget {
  final String profileId;
  OtherHeaderProfile({this.profileId});
  @override
  _OtherHeaderProfileState createState() => _OtherHeaderProfileState();
}

class _OtherHeaderProfileState extends State<OtherHeaderProfile> {
  bool isInit = true;
  Future getUserProfileData;
  Repository _repository = Repository();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      getUserProfileData = _repository.getOtherUserProfile(widget.profileId);
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.2;
    return Scaffold(
      body: FutureBuilder<UserModel>(
          future: getUserProfileData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
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
                            imageUrl: snapshot?.data?.imageProfile,
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
                          left: 20.0,
                          right: 0.0,
                          bottom: -10.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${snapshot.data.username.isNotEmpty ? snapshot?.data?.username : ''}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              snapshot.data.status == 'verified_identitas'
                                  ? Icon(
                                      Icons.verified_user,
                                      size: 20.0,
                                      color: Themes.primaryBlue,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                    height: 55.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Themes.primaryBlue),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        gridColumnDetail('Posts', '${snapshot.data.posts}'),
                        gridColumnDetail('Views', '${snapshot.data.views}'),
                        gridColumnDetail('Points', '${snapshot.data.points}'),
                      ],
                    ),
                  ),
                  snapshot.data.shortBio != null
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
          }),
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
