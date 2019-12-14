import 'package:flutter/material.dart';

class BannerArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.grey,
            ),
          ),
          Positioned(
            left: 20.0,
            top: 20.0,
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
