import 'package:flutter/material.dart';
import 'package:localin/model/facilities_model.dart';
import 'package:localin/presentation/booking/widgets/room_detail_title.dart';
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
        RowFacilities(list),
      ],
    );
  }
}

class RowFacilities extends StatelessWidget {
  final List<FacilitiesModel> listFacility;

  RowFacilities(this.listFacility);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
            children: List.generate(listFacility.length, (index) {
          return singleFacility(index, listFacility);
        }))
      ],
    );
  }

  Widget singleFacility(int index, var list) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ImageIcon(
            ExactAssetImage(list[index].icon),
            color: Themes.primaryBlue,
          ),
          SizedBox(
            height: 3.0,
          ),
          Text(
            list[index].title,
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
