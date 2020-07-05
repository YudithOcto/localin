import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/community/community_event/provider/community_create_event_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_gallery_image_widget.dart';
import 'package:localin/presentation/gallery/multi_picker_gallery_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CreateCommunityEventAddImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityCreateEventProvider>(
      builder: (context, provider, child) {
        return provider.selectedImage.isNotEmpty
            ? CommunityEventGalleryImageWidget()
            : InkWell(
                onTap: () async {
                  final result = await Navigator.of(context)
                      .pushNamed(MultiPickerGalleryPage.routeName, arguments: {
                    MultiPickerGalleryPage.chosenImage: provider.selectedImage,
                  });
                  if (result != null && result is List<Uint8List>) {
                    provider.addSelectedImage(result);
                  }
                },
                child: Container(
                  width: double.maxFinite,
                  height: 200.0,
                  margin: EdgeInsets.only(bottom: 24.0),
                  color: ThemeColors.black10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset('images/image_icon.svg'),
                      SizedBox(
                        height: 16.37,
                      ),
                      Text(
                        'Tap to add images up to 10 images',
                        style: ThemeText.sfRegularBody
                            .copyWith(color: ThemeColors.black80),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
