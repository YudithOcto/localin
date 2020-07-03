import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/provider/create/community_create_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

import '../community_type_page.dart';

class CommunityEditTypeOnlyWidget extends StatelessWidget {
  final CommunityDetail detail;
  CommunityEditTypeOnlyWidget({@required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
      child: InkWell(
        onTap: () {
          if (detail.status == kFreeCommunity) {
            final provider = Provider.of<CommunityCreateProvider>(context);
            Navigator.of(context)
                .pushNamed(CommunityTypePage.routeName, arguments: {
              CommunityTypePage.requestModel: provider.requestModel,
            });
          } else {
            if (detail?.expiredAt != null &&
                DateTime.now().isAfter(DateTime.parse(detail.expiredAt))) {
              final provider = Provider.of<CommunityCreateProvider>(context);
              Navigator.of(context)
                  .pushNamed(CommunityTypePage.routeName, arguments: {
                CommunityTypePage.requestModel: provider.requestModel,
              });
            }
          }
        },
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: detail?.communityType?.backgroundCommunityTypeColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Subtitle(
                title: 'community type',
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: detail
                          ?.communityType?.backgroundTextContainerTypeColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 4.0),
                      child: Text(
                        '${detail.communityType == kFreeCommunity ? 'STANDARD' : 'PRO'}',
                        style: ThemeText.sfSemiBoldCaption
                            .copyWith(color: ThemeColors.black0),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    detail.communityType == kFreeCommunity
                        ? 'Upgrade to unlock pro feature'
                        : 'Expired on ${DateHelper.formatDate(date: DateTime.parse(detail.expiredAt), format: 'dd MMM yyyy')}',
                    style: ThemeText.sfMediumBody,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  Color get backgroundCommunityTypeColor {
    return this == kFreeCommunity ? ThemeColors.black10 : ThemeColors.green10;
  }

  Color get backgroundTextContainerTypeColor {
    return this == kFreeCommunity ? ThemeColors.black80 : ThemeColors.green;
  }

  String get typeText {
    print(this == kFreeCommunity);
    return this == kFreeCommunity
        ? 'Upgrade to unlock pro feature'
        : 'Expired on';
  }
}
