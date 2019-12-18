import 'package:flutter/material.dart';
import 'package:localin/presentation/article/widget/recommended_card.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/constants.dart';

import '../../../themes.dart';

class ArticleCommentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: List.generate(3, (index) {
            return Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Person 1',
                              style: kValueStyle.copyWith(
                                  color: Themes.primaryBlue),
                            ),
                            Text(
                              '4 jan',
                              style: kValueStyle.copyWith(
                                  fontSize: 10.0, color: Colors.black26),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      kRandomWords,
                      style: kValueStyle.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Berikan Comentar',
                    border: UnderlineInputBorder()),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Icon(
              Icons.send,
              size: 35.0,
            )
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        RecommendedCard()
      ],
    );
  }
}
