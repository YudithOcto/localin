import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddImageGalleryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: AssetImage('images/create_article_image.png'),
                fit: BoxFit.cover,
              )),
        ),
        Container(
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color.fromRGBO(0, 0, 0, 0.8),
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: SvgPicture.asset(
            'images/camera.svg',
            alignment: Alignment.center,
            fit: BoxFit.scaleDown,
          ),
        )
      ],
    );
  }
}
