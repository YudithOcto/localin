import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/calendar_page/calendar_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/single_column_bottom_sheet_search_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';
import 'package:snaplist/snaplist.dart';

class HotelBottomSheetSortWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HotelListSearchProvider>(
      create: (_) => HotelListSearchProvider(),
      child: LayoutBuilder(
        builder: (context, boxConstraint) {
          return Container(
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
                      child: SingleColumnBottomSheetSearchWidget(
                        title: 'WHERE YOU GO?',
                        value: 'Nearby',
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
                                        .pushNamed(CalendarPage.routeName);
                                    if (result != null && result is DateTime) {
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
                    Consumer<HotelListSearchProvider>(
                      builder: (_, provider, __) {
                        return Flexible(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              final listCheckout =
                                  provider.getListCheckOutDate();
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0, top: 27.0),
                                      decoration: BoxDecoration(
                                          color: ThemeColors.black0,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                          )),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Choose Duration of Stay',
                                            style: ThemeText.sfSemiBoldHeadline
                                                .copyWith(
                                                    color: ThemeColors.black80),
                                          ),
                                          SizedBox(height: 12.0),
                                          Expanded(
                                            child: SnapList(
                                              axis: Axis.vertical,
                                              separatorProvider:
                                                  (index, data) =>
                                                      Size(10.0, 10.0),
                                              sizeProvider: (index, data) =>
                                                  Size(
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      100.0),
                                              builder: (context, index, data) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 16.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        '${index + 1} night(s)',
                                                        style: ThemeText
                                                            .sfMediumHeadline
                                                            .copyWith(
                                                                color: ThemeColors
                                                                    .primaryBlue),
                                                      ),
                                                      Text(
                                                        listCheckout[index],
                                                        style: ThemeText.sfRegularBody.copyWith(
                                                            color: data.center ==
                                                                    index - 2
                                                                ? ThemeColors
                                                                    .primaryBlue
                                                                : ThemeColors
                                                                    .primaryBlue
                                                                    .withOpacity(
                                                                        0.3)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              count: listCheckout.length,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: SingleColumnBottomSheetSearchWidget(
                              title: 'DURATION',
                              value: '1 Night(s)',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
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
                      child: SingleColumnBottomSheetSearchWidget(
                        title: 'TOTAL ROOM(S) & GUEST(S)',
                        value: '1 Room, 1 Guest',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 33.0),
                Container(
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
