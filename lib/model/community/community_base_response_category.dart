import 'package:localin/model/community/community_category.dart';

class CommunityBaseResponseCategory {
  String error;
  String message;
  List<CommunityCategory> communityCategory;

  CommunityBaseResponseCategory(
      {this.error, this.message, this.communityCategory});

  factory CommunityBaseResponseCategory.fromJson(Map<String, dynamic> body) {
    List data = body['data'];
    return CommunityBaseResponseCategory(
      error: null,
      message: body['message'],
      communityCategory:
          data.map((value) => CommunityCategory.fromJson(value)).toList(),
    );
  }

  CommunityBaseResponseCategory.withError(String value)
      : error = value,
        communityCategory = List();
}
