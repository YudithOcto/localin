import 'package:flutter/material.dart';
import 'package:localin/utils/constants.dart';

class BottomCompanyInformation extends StatelessWidget {
  final kValueStyle = TextStyle(
      fontSize: 9.0, color: Colors.white, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      margin: EdgeInsets.only(top: 10.0),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                    child: Image.asset(
                      'images/localin_logo_white.png',
                      fit: BoxFit.cover,
                      height: 30.0,
                    ),
                  ),
                  Text(
                    'Copyright @ 2019 PT. Lokal Karya Nusantara. All Right deserved.',
                    style: kValueStyle.copyWith(
                        fontSize: 9.0, color: Colors.white),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: 4.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      Constants.kAddress,
                      style: kValueStyle.copyWith(
                          fontSize: 9.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 15.0),
                height: 120.0,
                width: 3.0,
                color: Colors.grey,
              ),
              FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'About Us',
                      style: kValueStyle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Career',
                      style: kValueStyle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Contact',
                      style: kValueStyle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Terms & Condition',
                      overflow: TextOverflow.ellipsis,
                      style: kValueStyle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Maps',
                      style: kValueStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15.0,
              )
            ],
          )
        ],
      ),
    );
  }
}
