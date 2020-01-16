import 'package:flutter/material.dart';
import 'package:localin/model/facilities_model.dart';
import 'package:localin/presentation/hotel/widgets/room_detail_title.dart';
import 'package:localin/themes.dart';

class RoomGeneralFacilities extends StatelessWidget {
  createFacilityModel() {
    final List<FacilitiesModel> facilityList = List();
    facilityList.add(addModel('AC', iconData[0]));
    facilityList.add(addModel('Restaurant', iconData[1]));
    facilityList.add(addModel('Swimming Pool', iconData[2]));
    facilityList.add(addModel('24 Hour Front Desk', iconData[3]));
    facilityList.add(addModel('Parking Area', iconData[4]));
    facilityList.add(addModel('Elevator', iconData[5]));
    facilityList.add(addModel('WIFI', iconData[6]));
    return facilityList;
  }

  addModel(String title, String icon) {
    FacilitiesModel model = FacilitiesModel();
    model.title = title;
    model.icon = icon;
    return model;
  }

  final iconData = [
    'images/facilities_ac.png',
    'images/facilities_restaurant.png',
    'images/facilities_swimming.png',
    'images/facilities_24_hour.png',
    'images/facilities_parking.png',
    'images/facilities_elevator.png',
    'images/facilities_wifi.png'
  ];
  @override
  Widget build(BuildContext context) {
    var list = createFacilityModel();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoomDetailTitle(
          title: 'General Facilities',
        ),
        SizedBox(
          height: 10.0,
        ),
        RowFacilities(list),
        Container(
          color: Colors.black38,
          height: 1,
          width: double.infinity,
          margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                buttonDate(),
              ],
            ),
            Icon(
              Icons.arrow_forward,
              color: Themes.silverGrey,
            ),
            Column(
              children: <Widget>[
                Text('Check in',
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 8.0,
                ),
                buttonDate(),
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
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.remove_circle_outline,
                      color: Themes.dimGrey,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '1',
                      style:
                          TextStyle(fontSize: 14.0, color: Themes.primaryBlue),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.add_circle_outline,
                      size: 20.0,
                      color: Themes.dimGrey,
                    )
                  ],
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

  Widget buttonDate() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Themes.dimGrey)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
        child: Text(
          '01 Nov, 2019',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.0,
              color: Themes.primaryBlue),
        ),
      ),
    );
  }
}

class RowFacilities extends StatelessWidget {
  final List<FacilitiesModel> listFacility;

  RowFacilities(this.listFacility);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(listFacility.length, (index) {
          return singleFacility(index);
        }));
  }

  Widget singleFacility(int index) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Image.asset(
            '${listFacility[index].icon}',
            width: 25.0,
            height: 25.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            listFacility[index].title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: Themes.primaryBlue),
          )
        ],
      ),
    );
  }
}
