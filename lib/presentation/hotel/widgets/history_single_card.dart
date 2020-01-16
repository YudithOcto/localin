import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';

class HistorySingleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5.0,
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'No. Pesanan 128783273',
                    style: kTitleStyle,
                  ),
                  Text(
                    'Rp 603.337',
                    style: kValueStyle,
                  ),
                ],
              ),
            ),
            Container(
              color: Themes.greyGainsBoro,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ImageIcon(
                      ExactAssetImage('images/train_icon.png'),
                      color: Themes.primaryBlue,
                    ),
                    widthDivider(),
                    Text(
                      'Cirebon',
                      style: kValueStyle,
                    ),
                    widthDivider(),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 15.0,
                    ),
                    widthDivider(),
                    Text(
                      'Jakarta',
                      style: kValueStyle,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Pembelian Berhasil',
                    style: kTitleStyle.copyWith(color: Themes.green),
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: Themes.primaryBlue,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget widthDivider() {
    return SizedBox(
      width: 10.0,
    );
  }
}
