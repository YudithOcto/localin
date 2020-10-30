import 'package:intl/intl.dart';

String getFormattedCurrency(int value) {
  if (value == null) return '';
  if (value == 0) return 'IDR 0';
  final formatter = NumberFormat('#,##0', 'en_US');
  return 'IDR ${formatter.format(value)}';
}

int increasePriceCalculation(int price) {
  if (price == null) return 0;
  double finalPrice = (40 / 100) * price.toDouble();
  price = finalPrice.toInt() + price;
  return price;
}
