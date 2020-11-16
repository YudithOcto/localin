import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/presentation/calendar_page/calendar_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_bottom_sheet_duration_stay_builder.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_bottom_sheet_room_guest_builder.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/single_column_bottom_sheet_search_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_search/hotel_revamp_search_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class HotelBottomSheetBuilder extends StatelessWidget {
  final RevampHotelListRequest previousRequest;

  HotelBottomSheetBuilder({this.previousRequest});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HotelListSearchProvider>(
      create: (_) => HotelListSearchProvider(
        request: previousRequest,
        detail: HotelDetailEntity(isBookmark: false),
      ),
      child: LayoutBuilder(
        builder: (context, boxConstraint) {
          return WillPopScope(
            onWillPop: () async {
              Map<String, RevampHotelListRequest> map = Map();
              map['not_refresh'] =
                  Provider.of<HotelListSearchProvider>(context).requestModel;
              Navigator.of(context).pop(map);
              return false;
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'images/location.svg',
                        width: 16.0,
                        height: 20.0,
                      ),
                      SizedBox(width: 21.0),
                      Expanded(
                        child: InkResponse(
                          onTap: () async {
                            final result = await Navigator.of(context)
                                .pushNamed(HotelRevampSearchPage.routeName,
                                    arguments: {
                                  HotelRevampSearchPage.hotelRevampRequest:
                                      Provider.of<HotelListSearchProvider>(
                                              context)
                                          .requestModel,
                                });
                            if (result != null) {
                              Provider.of<HotelListSearchProvider>(context)
                                  .searchKeyword = result;
                            }
                          },
                          child: SingleColumnBottomSheetSearchWidget(
                            title: 'WHERE YOU GO?',
                            value:
                                '${Provider.of<HotelListSearchProvider>(context).search}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26.0),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'images/calendar.svg',
                              width: 16.0,
                              height: 20.0,
                            ),
                            SizedBox(width: 21.0),
                            Consumer<HotelListSearchProvider>(
                              builder: (_, provider, __) {
                                return Expanded(
                                  child: InkResponse(
                                    highlightColor: ThemeColors.primaryBlue,
                                    onTap: () async {
                                      final result = await Navigator.of(context)
                                          .pushNamed(CalendarPage.routeName,
                                              arguments: {
                                            CalendarPage.defaultDate:
                                                provider.checkIn,
                                          });
                                      if (result != null &&
                                          result is DateTime) {
                                        provider.checkInDate = result;
                                      }
                                    },
                                    child: SingleColumnBottomSheetSearchWidget(
                                      title: 'CHECK IN DATE',
                                      value: '${provider.currentCheckInDate}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 25.0),
                      HotelBottomSheetDurationStayBuilder(),
                    ],
                  ),
                  SizedBox(height: 13.0),
                  Consumer<HotelListSearchProvider>(
                    builder: (_, provider, __) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 41.0),
                        child: Text(
                          provider.currentCheckoutDate,
                          style: ThemeText.sfSemiBoldFootnote
                              .copyWith(color: ThemeColors.black80),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 26.0),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'images/icon_user.svg',
                        width: 16.0,
                        height: 20.0,
                      ),
                      SizedBox(width: 21.0),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final result = await showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  final provider =
                                      Provider.of<HotelListSearchProvider>(
                                          context);
                                  return HotelBottomSheetRoomGuestBuilder(
                                    totalPreviousRoomRequest:
                                        provider.totalRoomSelected,
                                    totalPreviousChildRequest:
                                        provider.totalChildSelected,
                                    totalPreviousAdultRequest:
                                        provider.totalAdultSelected,
                                  );
                                });
                            if (result != null) {
                              Provider.of<HotelListSearchProvider>(context,
                                      listen: false)
                                  .changeRoomAndGuest = result;
                            }
                          },
                          child: Consumer<HotelListSearchProvider>(
                            builder: (_, provider, __) {
                              return SingleColumnBottomSheetSearchWidget(
                                title: 'TOTAL ROOM(S) & GUEST(S)',
                                value: '${provider.totalRoomSelected} Room, '
                                    '${provider.totalGuestSelected} Guest',
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 33.0),
                  InkResponse(
                    highlightColor: ThemeColors.primaryBlue,
                    onTap: () {
                      Map<String, RevampHotelListRequest> map = Map();
                      map[kRefresh] =
                          Provider.of<HotelListSearchProvider>(context)
                              .requestModel;
                      Navigator.of(context).pop(map);
                    },
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: ThemeColors.primaryBlue,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        'Search',
                        textAlign: TextAlign.center,
                        style: ThemeText.rodinaTitle3
                            .copyWith(color: ThemeColors.black0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
