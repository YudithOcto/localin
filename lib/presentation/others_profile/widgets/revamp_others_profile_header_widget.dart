import 'package:flutter/material.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/presentation/others_profile/widgets/row_user_community_article_widget.dart';
import 'package:localin/utils/constants.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class RevampOthersProfileHeaderWidget extends StatefulWidget {
  final UserModel userModel;

  RevampOthersProfileHeaderWidget({this.userModel});

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
                      '${widget.userModel?.username ?? ''}',
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
                    UserProfileImageWidget(
                      imageUrl: widget.userModel?.imageProfile,
                      isVerifyUser:
                          widget.userModel?.status == kUserStatusVerified,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Visibility(
                      visible: widget.userModel.type != 'media',
                      child: RowUserCommunityArticleWidget(
                        icon: 'images/other_profile_community_icon.svg',
                        title: 'community',
                        value: '${widget.userModel?.totalCommunity ?? 0}',
                      ),
                    ),
                    SizedBox(
                      width: 26.0,
                    ),
                    RowUserCommunityArticleWidget(
                      icon: 'images/other_profile_article_icon.svg',
                      title: 'articles',
                      value: '${widget.userModel?.totalArticle ?? 0}',
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
                  '${widget?.userModel?.shortBio?.text ?? ''}',
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

extension on String {
  String get text {
    print(this);
    if (this == null || this.isEmpty) return '-';
    return this;
  }
}
