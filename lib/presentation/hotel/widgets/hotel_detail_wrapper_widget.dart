import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/presentation/home/gallery_photo_view.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';
import 'package:localin/presentation/hotel/widgets/room_description.dart';
import 'package:localin/presentation/hotel/widgets/room_general_facilities.dart';
import 'package:localin/presentation/hotel/widgets/room_location.dart';
import 'package:localin/presentation/hotel/widgets/room_property_policies.dart';
import 'package:localin/presentation/hotel/widgets/room_recommended_by_property.dart';
import 'package:localin/presentation/hotel/widgets/room_type.dart';
import 'package:localin/presentation/profile/profile_page.dart';

class HotelDetailWrapperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    var size = MediaQuery.of(context).size;
    return Consumer<HotelDetailProvider>(
      builder: (_, provider, child) {
        return SingleChildScrollView(
          physics: platform == TargetPlatform.android
              ? ClampingScrollPhysics()
              : BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryPhotoView(
                        galleryItems: provider.hotelDetailEntity.images,
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        initialIndex: 0,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: <Widget>[
                    CarouselSlider.builder(
                      aspectRatio: 2.0,
                      itemCount: provider.hotelDetailEntity.images.length,
                      itemBuilder: (BuildContext context, int itemIndex) =>
                          CachedNetworkImage(
                              width: double.infinity,
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? size.height * 0.3
                                  : size.height * 0.6,
                              imageUrl: provider
                                  ?.hotelDetailEntity?.images[itemIndex],
                              fit: BoxFit.cover,
                              fadeInCurve: Curves.bounceIn,
                              placeholderFadeInDuration:
                                  Duration(milliseconds: 500),
                              placeholder: (context, url) => Container(
                                    color: Colors.grey,
                                  ),
                              errorWidget: (context, url, _) => Container(
                                    color: Colors.grey,
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? size.height * 0.3
                                            : size.height * 0.6,
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                  )),
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 20.0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: ThemeColors.primaryBlue.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Lihat ${provider.hotelDetailEntity.images?.length} photos',
                            style: kValueStyle.copyWith(
                                color: Colors.white, fontSize: 12.0),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20.0,
                      left: 15.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.keyboard_backspace,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${provider?.hotelDetailEntity?.hotelName}',
                      style: kValueStyle.copyWith(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Colors.black54,
                    ),
                    RoomLocation(),
                    RoomDescription(),
                    RoomGeneralFacilities(),
                    RoomType(),
                    RoomPropertyPolicies(),
                    Visibility(
                        visible: false, child: RoomRecommendedByProperty())
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget rowStarReview() {
    final cardTextStyle = TextStyle(
        fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.black);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.star,
          color: ThemeColors.primaryBlue,
          size: 15.0,
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          '4.0',
          style: cardTextStyle.copyWith(
              fontSize: 11.0, color: ThemeColors.primaryBlue),
        ),
        SizedBox(
          width: 25.0,
        ),
        Text(
          '180 review',
          style: cardTextStyle.copyWith(fontSize: 11.0, color: Colors.black38),
        ),
      ],
    );
  }
}
