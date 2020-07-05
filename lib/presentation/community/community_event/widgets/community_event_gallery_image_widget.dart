import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_event/provider/community_create_event_provider.dart';
import 'package:localin/presentation/gallery/multi_picker_gallery_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityEventGalleryImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityCreateEventProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 200,
          margin: EdgeInsets.only(bottom: 24.0),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            itemCount: provider.selectedImage.length,
            itemBuilder: (context, index) {
              return Stack(
                children: <Widget>[
                  Container(
                    child: Image.memory(
                      provider.selectedImage[index],
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12.0,
                    left: 20.0,
                    child: darkContainer(
                        text:
                            '${index + 1} of ${provider.selectedImage.length}'),
                  ),
                  Positioned(
                    top: 12.0,
                    right: 20.0,
                    child: Row(
                      children: <Widget>[
                        darkContainer(
                            text: 'Remove',
                            onTap: () {
                              provider.removeSelectedImage(index);
                            }),
                        SizedBox(
                          width: 8.0,
                        ),
                        darkContainer(
                            text: 'Add',
                            onTap: () async {
                              final result = await Navigator.of(context)
                                  .pushNamed(MultiPickerGalleryPage.routeName,
                                      arguments: {
                                    MultiPickerGalleryPage.chosenImage:
                                        provider.selectedImage,
                                  });
                              if (result != null && result is List<Uint8List>) {
                                provider.addSelectedImage(result);
                              }
                            }),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget darkContainer({
    String text,
    VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: ThemeColors.brandBlack.withOpacity(0.8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            text,
            style:
                ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.black0),
          ),
        ),
      ),
    );
  }
}
