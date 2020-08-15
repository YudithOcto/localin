import 'package:flutter/material.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/presentation/revamp_hotel/hotel_bookmark_page/providers/hotel_bookmark_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_room_type_page/hotel_detail_room_type_pick_page.dart';
import 'package:localin/presentation/revamp_hotel/shared_widgets/hotel_single_row_widget.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelBookmarkPage extends StatefulWidget {
  static const routeName = 'HotelBookmarkPage';
  static const previousRequest = 'PreviousRequest';

  @override
  _HotelBookmarkPageState createState() => _HotelBookmarkPageState();
}

class _HotelBookmarkPageState extends State<HotelBookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    RevampHotelListRequest request = routes[HotelBookmarkPage.previousRequest];
    return ChangeNotifierProvider<HotelBookmarkProvider>(
      create: (_) => HotelBookmarkProvider(request),
      child: LayoutBuilder(builder: (context, innerBox) {
        return Scaffold(
          backgroundColor: ThemeColors.black10,
          appBar: AppBar(
            backgroundColor: ThemeColors.black0,
            titleSpacing: 0.0,
            leading: InkResponse(
              onTap: () {},
              child: Icon(
                Icons.arrow_back,
                color: ThemeColors.black80,
              ),
            ),
            title: Text(
              'Hotel Bookmarked',
              style: ThemeText.sfMediumHeadline,
            ),
          ),
          body: StreamBuilder<RoomState>(
              stream: Provider.of<HotelBookmarkProvider>(context, listen: false)
                  .stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    Provider.of<HotelBookmarkProvider>(context).pageRequest <=
                        1) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final provider = Provider.of<HotelBookmarkProvider>(context);
                  return ListView.builder(
                    itemCount: provider.hotelList.length + 1,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (snapshot.data == RoomState.empty) {
                        return Container();
                      } else if (index < provider.hotelList.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: HotelSingleRowWidget(
                            onRoomTypeClick: () async {
                              final result = await Navigator.of(context)
                                  .pushNamed(
                                      HotelDetailRoomTypePickPage.routeName,
                                      arguments: {
                                    HotelDetailRoomTypePickPage.hotelDetail:
                                        provider.hotelList[index],
                                    HotelDetailRoomTypePickPage.sortingRequest:
                                        request,
                                  });
                              if (result != null) {
                                provider.changeBookmarkLocally(index);
                              }
                            },
                            onTapBookmark: () async {
                              final response = await provider
                                  .unBookmark(provider.hotelList[index]);
                              CustomToast.showCustomBookmarkToast(
                                  context, response);
                            },
                            hotelDetail: provider.hotelList[index],
                          ),
                        );
                      } else if (provider.canLoadMore) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              }),
        );
      }),
    );
  }
}
