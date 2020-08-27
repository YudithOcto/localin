import 'package:equatable/equatable.dart';
import 'package:localin/model/explore/base_event_request_model.dart';

class ExploreEventLocalModel extends BaseEventRequestmodel with EquatableMixin {
  @override
  List<Object> get props => [id, title, subtitle, category];

  int id;
  int exploreId;
  String title;
  String subtitle;
  String category;
  String timeStamp;

  ExploreEventLocalModel({
    this.id,
    this.exploreId,
    this.title,
    this.subtitle,
    this.category,
    this.timeStamp,
  });

  factory ExploreEventLocalModel.fromJson(Map<String, dynamic> json) {
    return ExploreEventLocalModel(
      id: json['id'],
      exploreId: json['explore_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      category: json['category'],
      timeStamp: json['timeStamp'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'explore_id': exploreId,
        'title': title,
        'subtitle': subtitle,
        'category': category,
        'timeStamp': timeStamp,
      };
}
