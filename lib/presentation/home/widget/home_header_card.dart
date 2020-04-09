import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/presentation/article/pages/create_article_page.dart';
import 'package:localin/presentation/home/widget/circle_material_button.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/location_helper.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class HomeHeaderCard extends StatelessWidget {
  final Function() notifyParent;
  final double expandedHeight;
  HomeHeaderCard({@required this.notifyParent, this.expandedHeight});
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthProvider>(context);
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Consumer<UserLocation>(
          builder: (context, location, child) {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: CachedNetworkImage(
                imageUrl: LocationHelper.generateLocationPreviewImage(
                    location?.latitude, location?.longitude),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (context, item, index) => Column(
                  children: <Widget>[
                    Icon(Icons.error),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text('No Internet Connection')
                  ],
                ),
              ),
            );
          },
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
                              color: ThemeColors.primaryBlue,
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
        Positioned(
          bottom: -25.0,
          right: 20.0,
          child: CircleMaterialButton(
            backgroundColor: ThemeColors.red,
            onPressed: () async {
              var result = await Navigator.of(context)
                  .pushNamed(CreateArticlePage.routeName);
              if (result != null) {
                notifyParent();
              }
            },
            icon: Icons.add,
          ),
        )
      ],
    );
  }

//  @override
//  double get maxExtent => expandedHeight;
//
//  @override
//  double get minExtent => 0.0;
//
//  @override
//  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
