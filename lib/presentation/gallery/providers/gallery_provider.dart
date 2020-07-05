import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryProvider with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  int _lastPage;
  int get lastPage => _lastPage;
  List<Uint8List> assetList = [];
  List<Uint8List> selectedAsset = [];
  List<int> selectedBytes = [];

  addSelectedImage(Uint8List model) {
    selectedAsset.add(model);
    selectedBytes.add(model.lengthInBytes);
    notifyListeners();
  }

  removeSelectedImage(Uint8List model) {
    selectedAsset
        .removeWhere((element) => element.lengthInBytes == model.lengthInBytes);
    selectedBytes.remove(model.lengthInBytes);
    notifyListeners();
  }

  Future<List<Uint8List>> getImage(List<Uint8List> previousSelected) async {
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
            .map((e) async => await e.thumbDataWithSize(400, 400, quality: 100))
            .toList();
        Future<List<Uint8List>> futureList = Future.wait(future);
        List<Uint8List> result = await futureList;
        assetList.addAll(result);
        if (_currentPage == 1) {
          assetList.insert(0, Uint8List(5));
          if (previousSelected != null && previousSelected.isNotEmpty) {
            selectedAsset.clear();
            selectedAsset.addAll(previousSelected);
            selectedAsset
                .map((e) => selectedBytes.add(e.lengthInBytes))
                .toList();
//            assetList.map((e) => print(e.lengthInBytes)).toList();
//            selectedAsset
//                .map((e) => print('\n\n\n${e.lengthInBytes}'))
//                .toList();
            notifyListeners();
          }
        }
      }
      return assetList;
    } else {
      PhotoManager.openSetting();
      return assetList;
    }
  }
}
