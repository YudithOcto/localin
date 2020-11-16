import 'package:equatable/equatable.dart';

class DiscountStatus with EquatableMixin {
  String couponValue;
  int isUsingLocalPoint;
  DiscountStatus({this.couponValue, this.isUsingLocalPoint});
  @override
  List<Object> get props => [couponValue, isUsingLocalPoint];
}
