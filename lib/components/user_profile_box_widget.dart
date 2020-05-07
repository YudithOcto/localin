import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import '../themes.dart';

class UserProfileImageWidget extends StatelessWidget {
  final String imageUrl;
  final File imageFile;
  UserProfileImageWidget({this.imageUrl, this.imageFile});

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: SuperellipseShape(
        side: BorderSide(
            color: ThemeColors.black20, width: 8, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(48.0),
      ),
      child: imageFile != null
          ? Image.file(
              imageFile,
              fit: BoxFit.cover,
              width: 62.0,
              height: 62.0,
            )
          : CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 62.0,
                  width: 62.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fitWidth,
                  )),
                );
              },
              placeholder: (context, placeHolder) => Container(
                height: 62.0,
                width: 62.0,
                color: ThemeColors.black40,
              ),
              placeholderFadeInDuration: Duration(milliseconds: 250),
              errorWidget: (context, errorMsg, child) => Container(
                height: 62.0,
                width: 62.0,
                color: ThemeColors.black40,
              ),
            ),
    );
  }
}
