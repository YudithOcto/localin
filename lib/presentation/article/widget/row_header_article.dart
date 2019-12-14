import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';

class RowHeaderArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Source: Tangerang Online (Antara Foto/Fadli)',
            style: kValueStyle.copyWith(color: Colors.grey, fontSize: 10.0),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            'Kali Jalan Aria Putra Ciputat Sudak Sepekan Banyak Sampah, Keluarkan Bau Menyengat',
            style: kValueStyle.copyWith(fontSize: 20.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Senin, 12 agustus 2019',
                style:
                    kValueStyle.copyWith(fontSize: 10.0, color: Colors.black45),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.share),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(Icons.bookmark_border),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
