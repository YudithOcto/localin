import 'dart:io';

import 'package:equatable/equatable.dart';

import 'community_category.dart';

class CommunityCreateRequestModel extends Equatable {
  String locations;
  String communityName;
  String description;
  CommunityCategory category;
  String communityType;
  File imageFile;
  bool isEditMode;
  String communityId;

  CommunityCreateRequestModel({
    this.locations,
    this.communityName,
    this.description,
    this.category,
    this.communityType,
    this.imageFile,
    this.isEditMode = false,
    this.communityId,
  });

  @override
  List<Object> get props => [
        locations,
        communityName,
        description,
        category,
        communityType,
        imageFile,
        isEditMode,
        communityId,
      ];
}
