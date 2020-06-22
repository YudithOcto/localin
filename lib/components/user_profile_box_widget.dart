import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/utils/image_helper.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import '../themes.dart';

class UserProfileImageWidget extends StatelessWidget {
  final String imageUrl;
  final File imageFile;
  final BoxFit fit;
  UserProfileImageWidget(
      {this.imageUrl, this.imageFile, this.fit = BoxFit.fitWidth});

  @override
  Widget build(BuildContext context) {
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
              imageUrl: ImageHelper.addSubFixHttp(imageUrl) ?? '',
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 62.0,
                  width: 62.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                  )),
                );
              },
              placeholder: (context, placeHolder) => Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Container(
                    height: 62.0,
                    width: 62.0,
                    color: ThemeColors.black10,
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Icon(
                      Icons.photo,
                      color: ThemeColors.black80,
                    ),
                  ),
                ],
              ),
              placeholderFadeInDuration: Duration(milliseconds: 250),
              errorWidget: (context, errorMsg, child) => Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Container(
                    height: 62.0,
                    width: 62.0,
                    color: ThemeColors.black10,
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Icon(Icons.photo, color: ThemeColors.black80),
                  ),
                ],
              ),
            ),
    );
  }
}
