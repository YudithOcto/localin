import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoView extends StatefulWidget {
  GalleryPhotoView({
    this.loadingChild,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    this.memoryGalleryItems,
    this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleryItems;
  final List<Uint8List> memoryGalleryItems;
  final Axis scrollDirection;

  @override
  _GalleryPhotoViewState createState() => _GalleryPhotoViewState();
}

class _GalleryPhotoViewState extends State<GalleryPhotoView> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          PhotoViewGallery.builder(
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            scrollPhysics: const BouncingScrollPhysics(),
            builder: _buildItem,
            itemCount: widget.galleryItems != null
                ? widget.galleryItems.length
                : widget.memoryGalleryItems.length,
            loadingChild: widget.loadingChild,
            pageController: widget.pageController,
            onPageChanged: onPageChanged,
            scrollDirection: widget.scrollDirection,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "${currentIndex + 1} of ${widget.galleryItems.length} photos",
                style: ThemeText.rodinaHeadline
                    .copyWith(color: ThemeColors.black0),
              ),
            ),
          ),
          Positioned(
            top: 50.0,
            right: 28.0,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.close, color: ThemeColors.black0),
            ),
          )
        ],
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final item = widget.memoryGalleryItems != null
        ? widget.memoryGalleryItems[index]
        : widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: widget.memoryGalleryItems != null
          ? MemoryImage(item)
          : CachedNetworkImageProvider('$item',
              errorListener: () => Icon(Icons.error)),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
