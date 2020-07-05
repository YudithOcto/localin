import 'package:flutter/foundation.dart';

class CommunityTypeRequestModel {
  String duration;
  String communityType;
  String until;
  String price;

  CommunityTypeRequestModel({
    this.duration = 'Lifetime',
    this.communityType = 'Free',
    this.until = '-',
    this.price = '0',
  });
}
