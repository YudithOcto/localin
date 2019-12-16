import 'package:flutter/material.dart';
import 'package:localin/presentation/article/article_detail_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';

class ArticleSingleCard extends StatelessWidget {
  final int index;
  ArticleSingleCard(this.index);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(ArticleDetailPage.routeName),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            upperRow(),
            bigImages(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                '#Pembongkaran Makam #Tangerang',
                style: kValueStyle.copyWith(fontSize: 10.0, color: Themes.red),
              ),
            ),
            rowChat(),
            Divider()
          ],
        ),
      ),
    );
  }

  Widget upperRow() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25.0,
          backgroundImage: AssetImage(
            'images/article_icon.png',
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Text(
                  'Kali Jalan Aria Putra Ciputat sudah sepekan Banyak Sampah, Keluarkan Bau Menyengat',
                  overflow: TextOverflow.ellipsis,
                  style: kValueStyle,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Themes.green,
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Tangerang Online',
                        style: kValueStyle.copyWith(
                            color: Colors.white, fontSize: 10.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    '15 Oktober 2019',
                    style: kValueStyle.copyWith(
                        fontSize: 12.0, color: Colors.black45),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 5.0),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.black45,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget bigImages() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
      height: 150.0,
    );
  }

  Widget rowChat() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.favorite_border),
          Icon(Icons.chat_bubble_outline),
          Icon(Icons.share),
          Icon(Icons.bookmark_border),
        ],
      ),
    );
  }
}
