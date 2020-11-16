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
  final double width;
  final double height;
  final bool isVerifyUser;

  UserProfileImageWidget(
      {this.imageUrl,
      this.imageFile,
      this.isVerifyUser = false,
      this.fit = BoxFit.fitWidth,
      this.height = 62.0,
      this.width = 62.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Material(
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
                  width: width,
                  height: height,
                )
              : CachedNetworkImage(
                  imageUrl: ImageHelper.addSubFixHttp(imageUrl) ?? '',
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: height,
                      width: width,
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
                        height: height,
                        width: width,
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
                        height: height,
                        width: width,
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
        ),
        Positioned(
          right: -4.0,
          bottom: -4.0,
          child: Visibility(
            visible: isVerifyUser,
            child: SvgPicture.asset(
              'images/verified_profile.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
