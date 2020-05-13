import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ArticleCommentForm extends StatefulWidget {
  @override
  _ArticleCommentFormState createState() => _ArticleCommentFormState();
}

class _ArticleCommentFormState extends State<ArticleCommentForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Visibility(
          visible: false,
          child: Container(
            color: ThemeColors.black10,
            height: 37.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Reply to',
                  style: ThemeText.sfRegularFootnote
                      .copyWith(color: ThemeColors.black80),
                ),
                SvgPicture.asset('images/clear_icon.svg'),
              ],
            ),
          ),
        ),
        Container(
          color: ThemeColors.black0,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ThemeColors.black80,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Input your message',
                      hintStyle: ThemeText.sfRegularBody
                          .copyWith(color: ThemeColors.black80),
                      border: InputBorder.none),
                ),
              ),
              SvgPicture.asset('images/send.svg'),
            ],
          ),
        )
      ],
    );
  }
}
