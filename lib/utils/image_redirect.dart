import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/presentation/home/widget/stay/gallery_photo_view.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';

void redirectImage(BuildContext context, List<String> images) async {
  CustomDialog.showLoadingDialog(context, message: 'Loading . . .');
  final data = images.map((e) async => await networkImageToByte(e)).toList();
  Future<List<Uint8List>> future = Future.wait(data);
  List<Uint8List> results = await future;
  final memory = results.map((e) => MemoryImage(e)).toList();
  CustomDialog.closeDialog(context);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GalleryPhotoView(
        imageProviderItems: memory,
        initialIndex: 0,
        scrollDirection: Axis.horizontal,
      ),
    ),
  );
}
