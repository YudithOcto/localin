import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';

class RecommendedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Rekomendasi Untuk Kamu',
          style: kValueStyle.copyWith(fontSize: 20.0),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: 250.0,
          height: 250.0,
          child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SingleCard(
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SingleCard extends StatelessWidget {
  final int index;
  SingleCard({this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: 150.0,
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              height: 150.0,
              width: 150.0,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Truk Tanah kembali terguling di tanah',
                textAlign: TextAlign.center,
                style:
                    kValueStyle.copyWith(fontSize: 11.0, color: Colors.black87),
              ),
            ),
          )
        ],
      ),
    );
  }
}
