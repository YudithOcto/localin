import 'package:flutter/material.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/presentation/profile/profile_page.dart';

class CommunityFormInput extends StatefulWidget {
  @override
  _CommunityFormInputState createState() => _CommunityFormInputState();
}

class _CommunityFormInputState extends State<CommunityFormInput> {
  double size = 50.0;
  bool isImageShown = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15.0, right: 15.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              margin: EdgeInsets.only(right: size <= 50 ? 10.0 : 30.0),
              duration: Duration(milliseconds: 500),
              height: size,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(10.0),
              ),
              curve: Curves.easeInOut,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onTap: () {
                      setState(() {
                        size = 200.0;
                      });
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: InputBorder.none,
                        hintText: 'Tulis Sesuatu',
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                        )),
                  ),
                  Expanded(
                    child: Visibility(
                      visible: size > 50.0,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Visibility(
                              visible: isImageShown,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                                child: Icon(
                                  Icons.add_photo_alternate,
                                  size: 50.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isImageShown = true;
                                          });
                                        },
                                        child: Icon(Icons.attach_file),
                                      ),
                                      Text(
                                        'Tambah Foto/Video',
                                        textAlign: TextAlign.center,
                                        style: kValueStyle.copyWith(
                                            fontSize: 10.0,
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: RoundedButtonFill(
                                        onPressed: () {},
                                        title: 'Kirim',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: size <= 50.0,
            child: Container(
              margin: EdgeInsets.only(top: 15.0, right: 15.0),
              child: InkWell(
                onTap: () {},
                child: Icon(Icons.attach_file),
              ),
            ),
          )
        ],
      ),
    );
  }
}
