import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/themes.dart';

class CustomImageOnlyRadius extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double topLeft, topRight, bottomLeft, bottomRight;
  final Color placeHolderColor;
  final double width, height;

  CustomImageOnlyRadius(
      {this.imageUrl,
      this.placeHolderColor = ThemeColors.black80,
      this.width,
      this.height,
      this.topLeft = 0.0,
      this.topRight = 0.0,
      this.bottomRight = 0.0,
      this.bottomLeft = 0.0,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      imageBuilder: (context, imageProvider) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(topRight),
                topLeft: Radius.circular(topLeft),
                bottomLeft: Radius.circular(bottomLeft),
                bottomRight: Radius.circular(bottomRight),
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              )),
        );
      },
      errorWidget: (context, error, child) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topRight),
            topLeft: Radius.circular(topLeft),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
          color: placeHolderColor,
        ),
        child: SvgPicture.asset(
          'images/image_icon.svg',
          fit: BoxFit.scaleDown,
          height: 20.0,
          width: 20.0,
        ),
      ),
      placeholder: (context, child) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topRight),
            topLeft: Radius.circular(topLeft),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
          color: placeHolderColor,
        ),
      ),
      placeholderFadeInDuration: Duration(milliseconds: 400),
      fadeInCurve: Curves.easeIn,
    );
  }
}
