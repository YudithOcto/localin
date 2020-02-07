import 'package:flutter/material.dart';
import 'package:localin/presentation/hotel/widgets/room_detail_title.dart';
import 'package:localin/themes.dart';

class RoomRecommendedByProperty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoomDetailTitle(
          title: 'Recommended Properties',
        ),
        Container(
          height: 200.0,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return singleCardRecommendedProperties();
            },
          ),
        ),
      ],
    );
  }

  Widget singleCardRecommendedProperties() {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
//          ClipRRect(
//            borderRadius: BorderRadius.circular(8.0),
//            child: Image.asset(
//              'images/cafe.jpg',
//              fit: BoxFit.fill,
//              width: 150.0,
//            ),
//          ),
          Positioned(
            top: 70.0,
            child: Container(
              width: 150.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'RedDoorz Apartment near Summaarecon Mall Serpong',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                    child: Text(
                      'Kelapa Dua, Kab. Tangerang',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10.0,
                          color: Themes.grey,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
                    child: Text(
                      'Rp 275.000',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 9.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text(
                      'Rp 233.000',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Themes.primaryBlue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      '/room/night',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
