import 'package:flutter/material.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/room_guest_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/single_button_room_guest_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class HotelBottomSheetRoomGuestBuilder extends StatelessWidget {
  final int totalPreviousRequest;
  HotelBottomSheetRoomGuestBuilder({this.totalPreviousRequest = 1});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoomGuestProvider>(
      create: (_) => RoomGuestProvider(totalRoomSelected: totalPreviousRequest),
      child: LayoutBuilder(builder: (context, boxConstraint) {
        return Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 27.0),
          decoration: BoxDecoration(
              color: ThemeColors.black0,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
              )),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add Room(s) & Guest(s)',
                style: ThemeText.sfSemiBoldHeadline
                    .copyWith(color: ThemeColors.black80),
              ),
              SizedBox(height: 12.0),
              Consumer<RoomGuestProvider>(
                builder: (_, roomProvider, __) {
                  return HotelBottomSheetRoomGuestSingleRowWidget(
                    title: 'Room(s)',
                    add: () => roomProvider.changeRoomValue = true,
                    subtract: () => roomProvider.changeRoomValue = false,
                    value: roomProvider.roomSelected,
                    isChildren: false,
                  );
                },
              ),
              Divider(
                thickness: 2.0,
                color: ThemeColors.black40,
              ),
              Consumer<RoomGuestProvider>(builder: (_, roomProvider, __) {
                return HotelBottomSheetRoomGuestSingleRowWidget(
                  title: 'Adult(s)',
                  add: () => roomProvider.changeAdultValue = true,
                  subtract: () => roomProvider.changeAdultValue = false,
                  value: roomProvider.adultSelected,
                  isChildren: false,
                );
              }),
              Divider(
                thickness: 2.0,
                color: ThemeColors.black40,
              ),
              Consumer<RoomGuestProvider>(
                builder: (_, roomProvider, __) {
                  return HotelBottomSheetRoomGuestSingleRowWidget(
                    title: 'Children(s)',
                    add: () => roomProvider.changeChildValue = true,
                    subtract: () => roomProvider.changeChildValue = false,
                    value: roomProvider.childSelected,
                    isChildren: true,
                  );
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0, bottom: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: OutlineButtonDefault(
                      onPressed: () => Navigator.of(context).pop(),
                      buttonText: 'Cancel',
                    )),
                    SizedBox(width: 17.0),
                    Expanded(
                      child: FilledButtonDefault(
                        onPressed: () {
                          final provider =
                              Provider.of<RoomGuestProvider>(context);
                          Map<String, int> map = Map();
                          map[kRoom] = provider.roomSelected;
                          map[kAdult] = provider.adultSelected;
                          map[kChild] = provider.childSelected;
                          Navigator.of(context).pop(map);
                        },
                        buttonText: 'Apply',
                        textTheme: ThemeText.rodinaTitle3
                            .copyWith(color: ThemeColors.black0),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class HotelBottomSheetRoomGuestSingleRowWidget extends StatelessWidget {
  final String title;
  final VoidCallback add;
  final VoidCallback subtract;
  final int value;
  final bool isChildren;
  HotelBottomSheetRoomGuestSingleRowWidget(
      {this.title, this.add, this.subtract, this.value, this.isChildren});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title,
            style: ThemeText.sfMediumHeadline
                .copyWith(color: ThemeColors.primaryBlue)),
        Container(
          width: 114.0,
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: ThemeColors.black10, width: 2.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SingleButtonRoomGuestWidget(
                icon: Icon(
                  Icons.remove,
                  color: ThemeColors.orange80,
                ),
                backgroundColor:
                    (value <= 1 && !isChildren) || (value <= 0 && isChildren)
                        ? ThemeColors.black10
                        : ThemeColors.orange10,
                onPressed: subtract,
              ),
              Container(
                child: Text('$value',
                    style: ThemeText.rodinaHeadline
                        .copyWith(color: ThemeColors.primaryBlue)),
              ),
              SingleButtonRoomGuestWidget(
                icon: Icon(
                  Icons.add,
                  color: ThemeColors.orange80,
                ),
                backgroundColor: ThemeColors.orange10,
                onPressed: add,
              )
            ],
          ),
        )
      ],
    );
  }
}
