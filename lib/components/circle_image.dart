import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/themes.dart';

class CircleImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  CircleImage(
      {this.imageUrl,
      this.width = 19.0,
      this.height = 19.0,
      this.fit = BoxFit.contain});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      imageBuilder: (context, imageProvider) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ThemeColors.black10),
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              )),
        );
      },
      placeholder: (context, image) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeColors.black80,
        ),
      ),
      errorWidget: (context, image, child) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeColors.black80,
        ),
      ),
    );
  }
}
