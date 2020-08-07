import 'package:localin/model/explore/explore_filter_response_model.dart';

class ExploreFilterModelRequest {
  int sort;
  int month;
  List<CategoryExploreDetail> category;

  ExploreFilterModelRequest({this.sort, this.month, this.category});
}
