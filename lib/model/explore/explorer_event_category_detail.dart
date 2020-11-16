import 'package:localin/model/explore/base_event_request_model.dart';

class ExploreEventCategoryDetail extends BaseEventRequestmodel {
  String categoryId;
  String categoryName;
  int total;

  ExploreEventCategoryDetail({this.categoryId, this.categoryName, this.total});

  factory ExploreEventCategoryDetail.fromMap(Map<String, dynamic> json) {
    return ExploreEventCategoryDetail(
      categoryId: json['kategori_id'],
      categoryName: json['kategori_nama'],
      total: json['total'] == null ? 0 : json['total'],
    );
  }
}
