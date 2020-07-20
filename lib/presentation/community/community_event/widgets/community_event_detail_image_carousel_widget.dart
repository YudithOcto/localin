import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_detail_provider.dart';
import 'package:localin/presentation/shared_widgets/gallery_photo_view.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/image_redirect.dart';
import 'package:provider/provider.dart';

class CommunityEventDetailImageCarouselWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityEventDetailProvider>(
        builder: (context, provider, child) {
      return Container(
        margin: EdgeInsets.only(top: 15),
        child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 1.5,
            height: 175.82,
            autoPlay: false,
            enableInfiniteScroll: provider.eventResponse.attachment.length > 1,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
          ),
          items:
              List.generate(provider.eventResponse.attachment.length, (index) {
            return InkWell(
              onTap: () {
                List<String> list = List();
                provider.eventResponse.attachment
                    .map((e) => list.add(e.attachment))
                    .toList();
                redirectImage(context, list);
              },
              child: Stack(
                fit: StackFit.expand,
                overflow: Overflow.visible,
                children: <Widget>[
                  CustomImageRadius(
                    imageUrl:
                        provider.eventResponse.attachment[index].attachment,
                    width: double.maxFinite,
                    height: 175.82,
                    radius: 0.0,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: Visibility(
                      visible: provider.eventResponse.attachment.length > 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: ThemeColors.black100.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$index',
                            style: ThemeText.rodinaHeadline
                                .copyWith(color: ThemeColors.black0),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
