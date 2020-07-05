import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/presentation/gallery/providers/gallery_provider.dart';
import 'package:localin/presentation/shared_widgets/add_image_gallery_widget.dart';
import 'package:localin/presentation/shared_widgets/single_image_gallery_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class MultiPickerGalleryPage extends StatelessWidget {
  static const routeName = 'MultiPickerGallery';
  static const chosenImage = 'previousChosenImage';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GalleryProvider>(
      create: (_) => GalleryProvider(),
      child: GalleryWrapperContent(),
    );
  }
}

class GalleryWrapperContent extends StatefulWidget {
  @override
  _GalleryWrapperContentState createState() => _GalleryWrapperContentState();
}

class _GalleryWrapperContentState extends State<GalleryWrapperContent> {
  bool _isInit = true;
  Future getAsset;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      List<Uint8List> imageList = routeArgs[MultiPickerGalleryPage.chosenImage];
      getAsset = Provider.of<GalleryProvider>(context, listen: false)
          .getImage(imageList);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    final provider = Provider.of<GalleryProvider>(context, listen: false);
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (provider.currentPage != provider.lastPage) {
        setState(() {
          getAsset = Provider.of<GalleryProvider>(context, listen: false)
              .getImage(null);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        pageTitle: 'Gallery',
        titleStyle: ThemeText.rodinaHeadline,
        leadingIcon: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.close,
            color: ThemeColors.black80,
          ),
        ),
      ),
      body: NotificationListener(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return;
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer<GalleryProvider>(
            builder: (context, provider, child) {
              return FutureBuilder<List<Uint8List>>(
                  future: getAsset,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        provider.currentPage <= 0) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount:
                              snapshot.hasData ? snapshot.data.length + 1 : 1,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data == null ||
                                snapshot.data.isEmpty) {
                              return Container(
                                child: Center(
                                    child: Text('No Photo in recent history')),
                              );
                            } else if (index < snapshot.data.length) {
                              if (index == 0) {
                                return Center(child: AddImageGalleryWidget());
                              }
                              return InkWell(
                                onTap: () {
                                  if (index > 0) {
                                    if (provider.selectedAsset
                                            .contains(snapshot.data[index]) ||
                                        provider.selectedBytes.contains(snapshot
                                            .data[index].lengthInBytes)) {
                                      provider.removeSelectedImage(
                                          snapshot.data[index]);
                                    } else if (provider.selectedAsset.length <
                                        10) {
                                      provider.addSelectedImage(
                                          snapshot.data[index]);
                                    }
                                  }
                                },
                                child: SingleImageGalleryWidget(
                                  imageData: snapshot.data[index],
                                  provider: provider,
                                ),
                              );
                            } else if (provider.lastPage !=
                                provider.currentPage) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Container();
                            }
                          });
                    }
                  });
            },
          ),
        ),
      ),
      bottomNavigationBar: Consumer<GalleryProvider>(
        builder: (context, provider, child) {
          return Visibility(
            visible: provider.selectedAsset.isNotEmpty,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 27.0),
              child: RaisedButton(
                color: ThemeColors.primaryBlue,
                onPressed: () {
                  Navigator.of(context).pop(provider.selectedAsset);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Next',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
