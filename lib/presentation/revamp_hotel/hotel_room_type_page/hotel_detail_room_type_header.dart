import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/presentation/calendar_page/calendar_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_bottom_sheet_choose_checkout_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_bottom_sheet_room_guest_builder.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelDetailRoomTypeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<HotelListSearchProvider>(context, listen: false);
    return Container(
      color: ThemeColors.black0,
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkResponse(
            highlightColor: ThemeColors.primaryBlue,
            onTap: () async {
              final result = await Navigator.of(context)
                  .pushNamed(CalendarPage.routeName, arguments: {
                CalendarPage.defaultDate: provider.checkIn,
              });
              if (result != null) {
                provider.checkInDate = result;
                provider.getRoomAvailability();
              }
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset('images/calendar.svg',
                    width: 25.0, height: 20.0),
                SizedBox(width: 10.0),
                Text('${provider.currentCheckInDate}',
                    style: ThemeText.sfRegularFootnote),
              ],
            ),
          ),
          InkResponse(
            onTap: () async {
              final result = await showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return HotelBottomSheetChooseCheckoutWidget(
                      text: provider.getListCheckOutDate(),
                      currentIndex: provider.totalNightSelected,
                    );
                  });
              if (result != null) {
                provider.checkOutDate = result;
                provider.getRoomAvailability();
              }
            },
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 6.0),
                  child: SvgPicture.asset('images/icon_time.svg',
                      width: 25.0, height: 20.0),
                ),
                Text(
                  '${provider.totalNightSelected} Night(s)',
                  style: ThemeText.sfRegularFootnote,
                ),
              ],
            ),
          ),
          InkResponse(
            onTap: () async {
              final result = await showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return HotelBottomSheetRoomGuestBuilder(
                      totalPreviousRequest: provider.totalRoomSelected,
                    );
                  });
              if (result != null) {
                provider.totalRoomRequested = result;
                provider.getRoomAvailability();
              }
            },
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 8.0),
                  child: SvgPicture.asset('images/door_icon.svg',
                      width: 25.0, height: 20.0),
                ),
                Text('${provider.totalRoomSelected} Rooms',
                    style: ThemeText.sfRegularFootnote),
              ],
            ),
          )
        ],
      ),
    );
  }
}
