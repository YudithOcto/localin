import 'package:equatable/equatable.dart';
import 'package:localin/model/explore/base_event_request_model.dart';
import 'package:localin/model/explore/explore_event_response_model.dart';
import 'package:localin/model/explore/explorer_event_category_detail.dart';

class ExploreDefaultSearchResponse extends BaseEventRequestmodel
    with EquatableMixin {
  @override
  List<Object> get props => [error, message, category, location];

  bool error;
  String message;
  List<ExploreEventCategoryDetail> category;
  List<ExploreSearchLocation> location;

  ExploreDefaultSearchResponse(
      {this.error, this.message, this.category, this.location});

  factory ExploreDefaultSearchResponse.fromMap(Map<String, dynamic> body) {
    return ExploreDefaultSearchResponse(
      error: false,
      message: body['message'],
      category: body['data']['kategori'] == null
          ? []
          : List<ExploreEventCategoryDetail>.from(body['data']['kategori']
              .map((e) => ExploreEventCategoryDetail.fromMap(e))),
      location: body['data']['location'] == null
          ? []
          : List<ExploreSearchLocation>.from(body['data']['location']
              .map((e) => ExploreSearchLocation.fromJson(e))),
    );
  }

  ExploreDefaultSearchResponse.withError(String value)
      : message = value,
        error = true,
        category = [],
        location = [];
}
