import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

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
}
