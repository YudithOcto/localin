import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class SingleMemberWidget extends StatelessWidget {
  final String profileUrl;
  final bool isVerified;
  final String userName;
  final String joinedDate;
  final Function onPressed;

  SingleMemberWidget(
      {this.profileUrl,
      this.isVerified = false,
      this.userName,
      this.joinedDate,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            UserProfileImageWidget(
              imageUrl: '$profileUrl',
            ),
            Positioned(
              right: -4.0,
              bottom: -4.0,
              child: Visibility(
                visible: isVerified,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$userName',
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.primaryBlue)),
              Text(
                '$joinedDate',
                style: ThemeText.sfRegularFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
            ],
          ),
        ),
        InkWell(
            onTap: onPressed,
            child: Icon(Icons.more_vert, color: ThemeColors.black80))
      ],
    );
  }
}
