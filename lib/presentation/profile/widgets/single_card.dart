import 'package:flutter/material.dart';
import 'package:localin/components/bottom_company_information.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';
import 'header_profile.dart';

class SingleCard extends StatelessWidget {
  final int index;
  SingleCard(this.index);

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return HeaderProfile();
    } else if (index == 4) {
      return BottomCompanyInformation();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'images/cafe.jpg',
                fit: BoxFit.fill,
                width: 150.0,
                height: 90.0,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'FlyOver Gaplek di Bangun Akhir Agustus',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kValueStyle.copyWith(fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Themes.orange,
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4.0),
                          child: Text(
                            'Opinion',
                            style: kValueStyle.copyWith(
                                color: Colors.white,
                                fontSize: 10.0,
                                letterSpacing: -.5,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '27 Agustus 2019',
                        style: kValueStyle.copyWith(
                            fontSize: 10.0, color: Colors.black54),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}
