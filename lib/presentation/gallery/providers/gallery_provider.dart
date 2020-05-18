import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryProvider with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  int _lastPage;
  int get lastPage => _lastPage;
  List<Uint8List> assetList = [];
  Map<Uint8List, bool> selectedMap = Map();
  List<Uint8List> selectedAsset = [];

  Future<List<Uint8List>> getImage() async {
    _lastPage = _currentPage;
    final result = await PhotoManager.requestPermission();
    if (result) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(_currentPage, 60);
      if (media.isNotEmpty) {
        _currentPage += 1;
        final future = media
            .map((e) async => await e.thumbDataWithSize(340, 340, quality: 100))
            .toList();
        Future<List<Uint8List>> futureList = Future.wait(future);
        List<Uint8List> result = await futureList;
        assetList.addAll(result);
        if (_currentPage == 1) {
          assetList.insert(0, Uint8List(5));
        }
        assetList.map((v) => selectedMap[v] = false).toList();
      }
      return assetList;
    } else {
      PhotoManager.openSetting();
      return assetList;
    }
  }
}
