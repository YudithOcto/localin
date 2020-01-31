import 'package:flutter/material.dart';
import 'package:localin/presentation/hotel/widgets/room_detail_title.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/custom_date_range_picker.dart' as dtf;
import 'package:provider/provider.dart';

class RoomGeneralFacilities extends StatefulWidget {
  @override
  _RoomGeneralFacilitiesState createState() => _RoomGeneralFacilitiesState();
}

class _RoomGeneralFacilitiesState extends State<RoomGeneralFacilities> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HotelDetailProvider>(context);
    final detail = state.hotelDetailEntity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoomDetailTitle(
          title: 'General Facilities',
        ),
        SizedBox(
          height: 10.0,
        ),
        RowFacilities(detail?.facilities),
        Container(
          color: Colors.black38,
          height: 1,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 5.0),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Check in',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8.0,
                ),
                buttonDate(state.checkInDate, context),
              ],
            ),
            Icon(
              Icons.arrow_forward,
              color: Themes.silverGrey,
            ),
            Column(
              children: <Widget>[
                Text('Check out',
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 8.0,
                ),
                buttonDate(state.checkOutDate, context),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              color: Themes.darkGrey,
              width: 1.0,
              height: 50.0,
            ),
            Column(
              children: <Widget>[
                Text('Room(s)',
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 8.0,
                ),
                FittedBox(
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () => state.decreaseRoomTotal(),
                        child: Icon(
                          Icons.remove_circle_outline,
                          color: Themes.dimGrey,
                          size: 20.0,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${state.roomTotal}',
                        style: TextStyle(
                            fontSize: 14.0, color: Themes.primaryBlue),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      InkWell(
                        onTap: () => state.increaseRoomTotal(),
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 20.0,
                          color: Themes.dimGrey,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        Container(
          color: Colors.black38,
          height: 1,
          width: double.infinity,
          margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
        ),
      ],
    );
  }

  Widget buttonDate(DateTime value, BuildContext context) {
    final state = Provider.of<HotelDetailProvider>(context);
    return InkWell(
      onTap: () async {
        final List<DateTime> pick = await dtf.showDatePicker(
            context: context,
            initialFirstDate: state.checkInDate,
            initialLastDate: state.checkOutDate,
            firstDate: DateTime.now().subtract(Duration(days: 1)),
            lastDate: DateTime(2025));
        if (pick != null && pick.length == 2) {
          setState(() {
            state.setCheckInDate(pick[0]);
            state.setCheckOutDate(pick[1]);
            Provider.of<HotelDetailProvider>(context)
                .setRoomDateSearch(state.checkInDate, state.checkOutDate);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Themes.dimGrey)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
          child: Text(
            '${DateHelper.formatDateRangeToString(value)}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
                color: Themes.primaryBlue),
          ),
        ),
      ),
    );
  }
}

class RowFacilities extends StatelessWidget {
  final List<String> listFacility;

  RowFacilities(this.listFacility);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 2.0,
      children: List.generate(listFacility.length, (index) {
        return Center(
          child: Container(
            width: 120.0,
            height: 30.0,
            child: RaisedButton(
              elevation: 3.0,
              onPressed: () {},
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Text(
                '${listFacility[index]}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12.0,
                    color: Themes.primaryBlue,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      }),
    );
  }
}
