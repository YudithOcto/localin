import 'package:flutter/cupertino.dart';

class HomeHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    clippedPath.lineTo(0.0, size.height - 24);
    clippedPath.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 24);
    clippedPath.lineTo(size.width, 0.0);
    clippedPath.close();
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
