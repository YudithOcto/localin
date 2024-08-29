import 'package:flutter/material.dart';

import '../themes.dart';

class StarDisplay extends StatelessWidget {
  final double value;
  final double size;

  const StarDisplay({this.value = 0, this.size = 10.0});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return _buildStar(context, index);
        }));
  }

  Widget _buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= value) {
      icon = Icon(
        Icons.star_border,
        color: ThemeColors.primaryBlue,
        size: size,
      );
    } else if (index > value - 1 && index < value) {
      icon = Icon(
        Icons.star_half,
        color: Colors.blue,
        size: size,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: ThemeColors.primaryBlue,
        size: size,
      );
    }
    return icon;
  }
}
