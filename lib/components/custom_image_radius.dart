import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/themes.dart';

class CustomImageRadius extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double radius;
  final Color placeHolderColor;
  final double width, height;

  CustomImageRadius(
      {this.imageUrl,
      this.radius = 5.0,
      this.placeHolderColor = ThemeColors.black80,
      this.width,
      this.height,
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
              borderRadius: BorderRadius.circular(radius),
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
          borderRadius: BorderRadius.circular(radius),
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
          borderRadius: BorderRadius.circular(radius),
          color: placeHolderColor,
        ),
      ),
      placeholderFadeInDuration: Duration(milliseconds: 400),
      fadeInCurve: Curves.easeIn,
    );
  }
}
