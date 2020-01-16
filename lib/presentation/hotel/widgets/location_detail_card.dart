import 'package:flutter/material.dart';

import '../../../themes.dart';

class LocationDetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      'images/static_map_image.png',
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      alignment: FractionalOffset.center,
                      height: 25.0,
                      decoration: BoxDecoration(
                          color: Themes.primaryBlue,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0))),
                      child: Text(
                        'Lihat di Peta',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 11.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Text(
                'Beverly 90210 Serpong, Jl. Trimezia, Curug Sengareng, Kelapa Dua, Tangerang, Banten, Indonesia, 15810',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontSize: 12.0),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: 20.0,
            ),
            Expanded(
                child: customButtonWithBorder('Direction', Icons.call_made)),
            SizedBox(
              width: 10.0,
            ),
            Expanded(child: customButtonWithBorder('Call Hotel', Icons.call)),
            SizedBox(
              width: 20.0,
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget customButtonWithBorder(String title, IconData icon) {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Themes.primaryBlue, width: 2.0)),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            icon,
            color: Themes.primaryBlue,
            size: 15.0,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 12.0,
                color: Themes.primaryBlue,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
