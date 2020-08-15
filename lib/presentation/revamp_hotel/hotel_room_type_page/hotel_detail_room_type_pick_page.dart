import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import 'hotel_detail_room_type_list_builder.dart';

class HotelDetailRoomTypePickPage extends StatelessWidget {
  static const routeName = 'HotelDetailRoomTypePickPage';
  static const sortingRequest = 'SortingRequest';
  static const hotelDetail = 'HotelDetail';

  onBackPressed(BuildContext context) {
    final provider = Provider.of<HotelListSearchProvider>(context);
    if (provider.trackBookmark == provider.hotelDetail.isBookmark) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(kRefresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider<HotelListSearchProvider>(
      create: (_) => HotelListSearchProvider(
          request: routes[sortingRequest], detail: routes[hotelDetail]),
      child: LayoutBuilder(
        builder: (context, innerBox) {
          return WillPopScope(
            onWillPop: () async {
              onBackPressed(context);
              return false;
            },
            child: Scaffold(
              backgroundColor: ThemeColors.black10,
              appBar: AppBar(
                elevation: 2,
                backgroundColor: ThemeColors.black0,
                leading: InkResponse(
                  highlightColor: ThemeColors.primaryBlue,
                  onTap: () => onBackPressed(context),
                  child: Icon(Icons.arrow_back, color: ThemeColors.black80),
                ),
                titleSpacing: 0.0,
                title: Consumer<HotelListSearchProvider>(
                  builder: (_, provider, __) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${provider.hotelDetail.hotelName}',
                          style: ThemeText.sfMediumHeadline,
                        ),
                        Text(
                            '${provider.hotelDetail.shortAddress} • ${provider.hotelDetail.distance} from your location',
                            style: ThemeText.sfMediumCaption)
                      ],
                    );
                  },
                ),
                actions: <Widget>[
                  Consumer<HotelListSearchProvider>(
                    builder: (_, provider, __) {
                      return InkResponse(
                        highlightColor: ThemeColors.primaryBlue,
                        onTap: () async {
                          final result =
                              await Provider.of<HotelListSearchProvider>(
                                      context,
                                      listen: false)
                                  .changeBookmark();
                          CustomToast.showCustomBookmarkToast(context, result);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          child: SvgPicture.asset(
                            'images/${provider.hotelDetail.isBookmark ? 'bookmark_full' : 'bookmark_outline'}.svg',
                            color: provider.hotelDetail.isBookmark
                                ? ThemeColors.primaryBlue
                                : ThemeColors.black80,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: HotelDetailRoomTypeListBuilder(),
            ),
          );
        },
      ),
    );
  }
}
