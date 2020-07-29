import 'package:equatable/equatable.dart';
import 'package:localin/model/restaurant/restaurant_search_base_model.dart';

class RestaurantLocalModal extends RestaurantSearchBaseModel
    with EquatableMixin {
  @override
  List<Object> get props => [id, title, subtitle, category, dateTime];

  int id;
  int restaurantId;
  String title;
  String subtitle;
  String category;
  int dateTime;

  RestaurantLocalModal(
      {this.id,
      this.restaurantId,
      this.title,
      this.subtitle,
      this.category,
      this.dateTime});

  factory RestaurantLocalModal.fromJson(Map<String, dynamic> json) {
    return RestaurantLocalModal(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      category: json['category'],
      dateTime: json['dateTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'restaurant_id': restaurantId,
        'title': title,
        'subtitle': subtitle,
        'category': category,
        'datetime': dateTime,
      };
}
