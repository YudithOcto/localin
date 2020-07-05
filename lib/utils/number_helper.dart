import 'package:intl/intl.dart';

String getFormattedCurrency(int value) {
  if (value == null) return '';
  if (value == 0) return 'IDR 0';
  final formatter = NumberFormat('#,##0', 'en_US');
  return 'IDR ${formatter.format(value)}';
}
