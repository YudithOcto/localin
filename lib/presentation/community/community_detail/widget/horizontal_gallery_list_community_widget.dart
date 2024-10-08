import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_detail/provider/community_create_post_provider.dart';
import 'package:localin/presentation/gallery/multi_picker_gallery_page.dart';
import 'package:localin/presentation/shared_widgets/add_image_gallery_widget.dart';
import 'package:localin/presentation/shared_widgets/gallery_photo_view.dart';
import 'package:localin/presentation/shared_widgets/single_image_gallery_widget.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HorizontalGalleryListCommunityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityCreatePostProvider>(
        builder: (context, provider, child) {
      return Container(
        height: 133.0,
        width: double.maxFinite,
        margin: EdgeInsets.only(bottom: 28.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: provider.selectedImage.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context).pushNamed(
                        MultiPickerGalleryPage.routeName,
                        arguments: {
                          MultiPickerGalleryPage.chosenImage:
                              provider.selectedImage,
                        });
                    if (result != null && result is List<Uint8List>) {
                      provider.addSelectedImage(result);
                    }
                  },
                  child: Center(child: AddImageGalleryWidget()));
            } else {
              return InkWell(
                onTap: () {
                  final data = provider.selectedImage
                      .map((e) => MemoryImage(e))
                      .toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryPhotoView(
                        imageProviderItems: data,
                        backgroundDecoration: const BoxDecoration(
                          color: ThemeColors.black100,
                        ),
                        initialIndex: index - 1,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: SingleImageGalleryWidget(
                      imageData: provider.selectedImage[index - 1],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      );
    });
  }
}
