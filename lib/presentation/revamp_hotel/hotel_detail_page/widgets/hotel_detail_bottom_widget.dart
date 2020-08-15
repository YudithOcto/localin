import 'package:flutter/material.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_api_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_room_request_provider.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

import '../../hotel_room_type_page/hotel_detail_room_type_pick_page.dart';

class HotelDetailBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.0,
      child: Consumer<HotelDetailApiProvider>(
        builder: (_, provider, __) {
          return StreamBuilder<RoomState>(
            stream: Provider.of<HotelDetailRoomRequestProvider>(context,
                    listen: false)
                .roomStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  (snapshot.hasData && snapshot.data == RoomState.loading)) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final roomProvider =
                    Provider.of<HotelDetailRoomRequestProvider>(context);
                if (snapshot.data == RoomState.empty) {
                  return Container(
                    width: double.maxFinite,
                    color: ThemeColors.black0,
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButtonDefault(
                      backgroundColor: ThemeColors.black10,
                      onPressed: () {
                        CustomToast.showCustomBookmarkToast(context,
                            'No Room available on this date. Please change Check in date on details section.');
                      },
                      buttonText: 'No room available',
                      textTheme: ThemeText.rodinaTitle3
                          .copyWith(color: ThemeColors.black60),
                    ),
                  );
                } else {
                  return Container(
                    height: 68.0,
                    color: ThemeColors.black0,
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Price /room/night start from',
                              style: ThemeText.sfRegularBody
                                  .copyWith(color: ThemeColors.black80),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        '${getFormattedCurrency(roomProvider.selectedRoom?.sellingAmount)}',
                                    style: ThemeText.rodinaTitle2
                                        .copyWith(color: ThemeColors.orange)),
                                TextSpan(
                                    text: '\tInclude Tax',
                                    style: ThemeText.sfSemiBoldCaption
                                        .copyWith(color: ThemeColors.black60)),
                              ]),
                            )
                          ],
                        ),
                        FilledButtonDefault(
                          onPressed: () async {
                            final result = await Navigator.of(context)
                                .pushNamed(
                                    HotelDetailRoomTypePickPage.routeName,
                                    arguments: {
                                  HotelDetailRoomTypePickPage.hotelDetail:
                                      provider.hotelDetailEntity,
                                  HotelDetailRoomTypePickPage.sortingRequest:
                                      provider.request,
                                });
                            if (result != null) {
                              provider.changeBookmarkLocally();
                            }
                          },
                          buttonText: 'Select Room',
                          textTheme: ThemeText.rodinaTitle3
                              .copyWith(color: ThemeColors.black0),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
