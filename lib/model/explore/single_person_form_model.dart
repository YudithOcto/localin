import 'package:equatable/equatable.dart';

class SinglePersonFormModel with EquatableMixin {
  @override
  List<Object> get props => [name, ticketType];

  String name;
  String ticketType;

  SinglePersonFormModel({this.ticketType, this.name});
}
