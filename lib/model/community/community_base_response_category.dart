import 'package:localin/model/community/community_category.dart';

class CommunityBaseResponseCategory {
  String error;
  String message;
  int total;
  List<CommunityCategory> communityCategory;

  CommunityBaseResponseCategory(
      {this.error, this.message, this.communityCategory, this.total});

  factory CommunityBaseResponseCategory.fromJson(Map<String, dynamic> body) {
    List data = body['data'];
    return CommunityBaseResponseCategory(
      error: null,
      message: body['message'],
      total: body['paging']['total'],
      communityCategory: data == null
          ? List()
          : data.map((value) => CommunityCategory.fromJson(value)).toList(),
    );
  }

  CommunityBaseResponseCategory.withError(String value)
      : error = value,
        communityCategory = List();
}
