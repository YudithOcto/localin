import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/gallery/providers/gallery_provider.dart';

class SingleImageGalleryWidget extends StatelessWidget {
  final GalleryProvider provider;
  final Uint8List imageData;

  SingleImageGalleryWidget({this.provider, @required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: MemoryImage(imageData),
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              width: 100.0,
              height: 90.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.5),
                    Color.fromRGBO(0, 0, 0, 0),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8.5,
              right: 5.0,
              child: Visibility(
                visible: provider != null,
                child: provider != null
                    ? SvgPicture.asset(
                        'images/${provider.selectedAsset.contains(imageData) ? 'circle_selected' : 'circle_not_selected'}.svg',
                        width: 23.0,
                        height: 23.0,
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
