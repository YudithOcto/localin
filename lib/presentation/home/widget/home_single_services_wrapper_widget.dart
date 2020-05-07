import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';

class HomeSingleServicesWrapperWidget extends StatelessWidget {
  final String serviceIcon;
  final String serviceName;
  final Function onPressed;

  HomeSingleServicesWrapperWidget(
      {this.serviceIcon, this.serviceName, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            'images/$serviceIcon',
            width: 62.0,
            height: 62.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '$serviceName',
            style: ThemeText.sfSemiBoldCaption.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
