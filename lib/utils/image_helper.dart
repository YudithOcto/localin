import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static String addSubFixHttp(String value) {
    if (value == null) return '';
    if (value.contains('http')) return value;
    return 'https://localin.sgp1.digitaloceanspaces.com/$value';
  }

  static Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    Uint8List byteImage = await networkImageToByte(imageUrl);
    await file.writeAsBytes(byteImage);
    return file;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
