import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

import 'hotel_bottom_sheet_builder.dart';

class QuickSearchRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future showBottomSheet(
        BuildContext context, RevampHotelListRequest request) {
      return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        )),
        builder: (BuildContext ctx) {
          return HotelBottomSheetBuilder(
            previousRequest: request,
          );
        },
      );
    }

    return InkResponse(
      highlightColor: ThemeColors.primaryBlue,
      onTap: () async {
        Map result = await showBottomSheet(context,
            Provider.of<HotelListProvider>(context).revampHotelListRequest);
        Future.delayed(Duration.zero, () {
          if (result != null) {
            if (result.containsKey(kRefresh)) {
              Provider.of<HotelListProvider>(context).revampHotelDataRequest =
                  result[kRefresh];
              Provider.of<HotelListProvider>(context)
                  .getRestaurantList(isRefresh: true);
            } else {
              Provider.of<HotelListProvider>(context).revampHotelDataRequest =
                  result['not_refresh'];
            }
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: ThemeColors.black0,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Consumer<HotelListProvider>(
          builder: (_, provider, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset('images/calendar.svg'),
                    SizedBox(width: 7.5),
                    Text(
                      '${DateHelper.checkInCheckOutTime(provider.revampHotelListRequest.checkIn, provider.revampHotelListRequest.checkout)}',
                      style: ThemeText.sfMediumCaption,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 12.0,
                        width: 1.0,
                        color: ThemeColors.black60,
                      ),
                    ),
                    Text(
                      ' ${provider.revampHotelListRequest.totalRooms} Room',
                      style: ThemeText.sfMediumCaption,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DashedLine(
                    color: ThemeColors.black20,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset('images/search_grey.svg'),
                    SizedBox(width: 13.75),
                    Text(
                        '${provider.revampHotelListRequest.search ?? 'Nearby'}',
                        style: ThemeText.sfRegularBody
                            .copyWith(color: ThemeColors.black100)),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
