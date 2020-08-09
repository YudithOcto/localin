import 'package:flutter/material.dart';

class SingleButtonRoomGuestWidget extends StatelessWidget {
  final Color backgroundColor;
  final Icon icon;
  final VoidCallback onPressed;
  SingleButtonRoomGuestWidget(
      {this.backgroundColor, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightColor: backgroundColor.withOpacity(0.7),
      onTap: onPressed,
      child: Container(
        width: 31.0,
        height: 28.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: backgroundColor,
        ),
        child: icon,
      ),
    );
  }
}
