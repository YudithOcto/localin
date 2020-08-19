import 'package:equatable/equatable.dart';
import 'package:localin/model/hotel/hotel_suggest_base.dart';

class HotelSuggestLocalModel extends HotelSuggestBase with EquatableMixin {
  @override
  List<Object> get props => [id, title, subtitle, category];

  int id;
  int hotelId;
  String title;
  String subtitle;
  String category;

  HotelSuggestLocalModel({
    this.id,
    this.hotelId,
    this.title,
    this.subtitle,
    this.category,
  });

  factory HotelSuggestLocalModel.fromJson(Map<String, dynamic> json) {
    return HotelSuggestLocalModel(
      id: json['id'],
      hotelId: json['hotel_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hotel_id': hotelId,
        'title': title,
        'subtitle': subtitle,
        'category': category,
      };
}
