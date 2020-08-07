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
    this.imageProviderItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<ImageProvider> imageProviderItems;
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
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: FractionalOffset.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(
                color: ThemeColors.black100,
              ),
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.imageProviderItems != null
                  ? widget.imageProviderItems.length
                  : 0,
              loadingChild: widget.loadingChild,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Text(
              "${currentIndex + 1} of ${widget?.imageProviderItems?.length ?? 1} photos",
              style:
                  ThemeText.rodinaHeadline.copyWith(color: ThemeColors.black0),
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
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final item = widget.imageProviderItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: item,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
