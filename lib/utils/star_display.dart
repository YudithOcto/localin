import 'package:flutter/material.dart';

import '../themes.dart';

class StarDisplay extends StatelessWidget {
  final double value;
  final double size;

  const StarDisplay({Key key, this.value = 0, this.size = 10.0})
      : assert(value != null),
        super(key: key);

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
        color: Themes.primaryBlue,
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
        color: Themes.primaryBlue,
        size: size,
      );
    }
    return icon;
  }
}
