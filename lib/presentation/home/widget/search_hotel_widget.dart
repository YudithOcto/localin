import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/presentation/home/widget/home_content_search_hotel.dart';
import 'package:localin/presentation/home/widget/search_form_widget.dart';

class SearchHotelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchFormWidget(),
        Container(
          padding: EdgeInsets.only(bottom: 70.0),
          child: Column(
            children: List.generate(5, (index) {
              return FadeAnimation(
                delay: 0.5,
                fadeDirection: FadeDirection.bottom,
                child: HomeContentSearchHotel(
                  index: index,
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
