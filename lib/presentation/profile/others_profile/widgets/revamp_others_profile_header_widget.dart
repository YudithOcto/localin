import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/profile/others_profile/widgets/row_user_community_article_widget.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../../text_themes.dart';
import '../../../../themes.dart';

class RevampOthersProfileHeaderWidget extends StatefulWidget {
  @override
  _RevampOthersProfileHeaderWidgetState createState() =>
      _RevampOthersProfileHeaderWidgetState();
}

class _RevampOthersProfileHeaderWidgetState
    extends State<RevampOthersProfileHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1F75E1), Color(0xFF094AAC)])),
        ),
        Positioned(
          top: 24.0,
          left: 20.0,
          right: 20.0,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        color: ThemeColors.black0,
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      'Dema Wiguna',
                      style: ThemeText.sfMediumHeadline
                          .copyWith(color: ThemeColors.black0),
                    )
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: <Widget>[
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        UserProfileBoxWidget(
                          imageUrl:
                              Provider.of<AuthProvider>(context, listen: false)
                                  .userModel
                                  .imageProfile,
                        ),
                        Positioned(
                          right: -4.0,
                          bottom: -4.0,
                          child: Visibility(
                            visible: true,
                            child: SvgPicture.asset(
                              'images/verified_profile.svg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    RowUserCommunityArticleWidget(
                      icon: 'images/other_profile_community_icon.svg',
                      title: 'community',
                      value: '14',
                    ),
                    SizedBox(
                      width: 26.0,
                    ),
                    RowUserCommunityArticleWidget(
                      icon: 'images/other_profile_article_icon.svg',
                      title: 'articles',
                      value: '23',
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'About',
                  style: ThemeText.sfSemiBoldBody
                      .copyWith(color: ThemeColors.black0.withOpacity(0.6)),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  'Actor, musician, songwriter. Mailbox: wiguna69@gmail.com *Rythm&Blues is Life*. Link new video // youtube.com/wiguna69',
                  style: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.black0),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
