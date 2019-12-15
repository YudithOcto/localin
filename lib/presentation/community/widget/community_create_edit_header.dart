import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';

class CommunityCreateEditHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: BackgroundClipper(),
          child: Container(
            color: Themes.primaryBlue,
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
          ),
        ),
        Positioned(
          top: 30.0,
          left: 15.0,
          child: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
          ),
        ),
        Positioned(
          left: 60.0,
          top: 30.0,
          child: Text(
            'Buat Komunitas',
            style: kValueStyle.copyWith(fontSize: 24.0, color: Colors.white),
          ),
        ),
        Positioned(
          left: 60.0,
          right: 60.0,
          top: 80.0,
          child: Text(
            'hubungkan bisnis, diri anda sendiri, atau gerakan ke komunitas orang di seluruh'
            'dunia dengan Localin. Untuk memulai, tentukan nama, lalu pilih kategori halaman.',
            style: kValueStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14.0),
          ),
        )
      ],
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    clippedPath.lineTo(0.0, size.height - 100);
    clippedPath.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    clippedPath.lineTo(size.width, 0.0);
    clippedPath.close();
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
