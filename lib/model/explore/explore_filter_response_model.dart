import 'package:equatable/equatable.dart';
import 'package:localin/model/explore/explore_base_model.dart';

class ExploreFilterResponseModel implements BaseModel {
  @override
  var detail;

  @override
  bool error;

  @override
  String message;

  @override
  int total;

  ExploreFilterResponseModel(
      {this.error, this.message, this.total, this.detail});

  factory ExploreFilterResponseModel.fromJson(Map<String, dynamic> json) {
    return ExploreFilterResponseModel(
        error: false,
        message: json['message'],
        total: json['data']['pagination']['total'],
        detail: json['data']['data'] == null
            ? null
            : List<CategoryExploreDetail>.from(json['data']['data']
                .map((e) => CategoryExploreDetail.fromJson(e))));
  }

  ExploreFilterResponseModel.withError(String value)
      : message = value,
        total = 0,
        detail = [],
        error = true;
}

class CategoryExploreDetail with EquatableMixin {
  String categoryId;
  String category;

  CategoryExploreDetail({this.categoryId, this.category});

  factory CategoryExploreDetail.fromJson(Map<String, dynamic> json) {
    return CategoryExploreDetail(
      categoryId: json['kategori_id'],
      category: json['kategori'],
    );
  }

  @override
  List<Object> get props => [category, categoryId];
}
