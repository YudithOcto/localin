import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/presentation/shared_widgets/gallery_photo_view.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelDetailPhotosPage extends StatelessWidget {
  static const routeName = 'HotelDetailPhotosPage';
  static const hotelDetail = 'HotelDetail';

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    HotelDetailEntity data = routes[hotelDetail];
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        leading: Icon(Icons.arrow_back, color: ThemeColors.black80),
        titleSpacing: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${data?.images?.length ?? 0} Photos',
              style: ThemeText.sfMediumHeadline,
            ),
            Text(
              '${data?.hotelName ?? ''}',
              style: ThemeText.sfMediumCaption,
            )
          ],
        ),
      ),
      body: Container(
        color: ThemeColors.black0,
        width: double.maxFinite,
        padding: EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 30.0),
        child: data.images != null
            ? GridView.count(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                children: List.generate(
                    data?.images?.length,
                    (index) => InkResponse(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GalleryPhotoView(
                                  imageProviderItems: data.images
                                      .map((e) => CachedNetworkImageProvider(e))
                                      .toList(),
                                  backgroundDecoration: const BoxDecoration(
                                    color: ThemeColors.black100,
                                  ),
                                  initialIndex: index - 1,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            );
                          },
                          highlightColor: ThemeColors.primaryBlue,
                          child: Padding(
                            padding: const EdgeInsets.all(7.5),
                            child: CustomImageRadius(
                              imageUrl: '${data?.images[index]}',
                              height: 100.0,
                              width: 100.0,
                              radius: 12.0,
                            ),
                          ),
                        )),
              )
            : Container(),
      ),
    );
  }
}
