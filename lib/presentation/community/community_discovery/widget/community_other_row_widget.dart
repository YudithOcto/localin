import 'package:flutter/material.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/presentation/community/provider/community_nearby_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class CommunityOtherRowWidget extends StatelessWidget {
  final CommunityDetail detail;

  CommunityOtherRowWidget({@required this.detail});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context)
            .pushNamed(CommunityDetailPage.routeName, arguments: {
          CommunityDetailPage.communityData: detail,
        });
      },
      child: Container(
        color: ThemeColors.black0,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Row(
          children: <Widget>[
            CustomImageRadius(
              height: 80.0,
              width: 80.0,
              radius: 8.0,
              imageUrl: detail.logoUrl ?? '',
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${detail.categoryName}'.toUpperCase(),
                    style: ThemeText.sfSemiBoldFootnote
                        .copyWith(color: ThemeColors.black80),
                  ),
                  Text(
                    '${detail?.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeText.rodinaHeadline,
                  ),
                  Text(
                    '${detail?.follower ?? 0} members',
                    style: ThemeText.sfMediumBody
                        .copyWith(color: ThemeColors.black80),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                if (detail.joinStatus == kJoinStatusNotJoin) {
                  CustomDialog.showLoadingDialog(context,
                      message: 'Please wait ...');
                  final result = await Provider.of<CommunityNearbyProvider>(
                          context,
                          listen: false)
                      .joinCommunity(detail.id);
                  CustomDialog.closeDialog(context);
                  if (result.error == null) {
                    CustomDialog.showCustomDialogWithButton(context,
                        'Join Community', '${result.message ?? 'Failed'}');
                  } else {
                    CustomDialog.showCustomDialogWithButton(context,
                        'Join Community', '${result.message ?? 'Success'}');
                  }
                } else {
                  Navigator.of(context)
                      .pushNamed(CommunityDetailPage.routeName, arguments: {
                    CommunityDetailPage.communityData: detail,
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: detail?.joinStatus == kJoinStatusWaiting
                        ? ThemeColors.black80
                        : ThemeColors.black0,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: ThemeColors.black20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  child: Text(
                    '${detail?.joinStatus}',
                    style: ThemeText.rodinaHeadline.copyWith(
                        color: detail?.joinStatus == kJoinStatusWaiting
                            ? ThemeColors.black0
                            : ThemeColors.primaryBlue),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
