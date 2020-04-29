import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:localin/provider/article/article_detail_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

class RowHeaderArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<ArticleDetailProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Source: ${state?.articleModel?.author}',
            style: kValueStyle.copyWith(color: Colors.grey, fontSize: 10.0),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            '${state?.articleModel?.title}',
            style: kValueStyle.copyWith(fontSize: 20.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${DateHelper.formatDateFromApi(state?.articleModel?.createdAt)}',
                style:
                    kValueStyle.copyWith(fontSize: 10.0, color: Colors.black45),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Share.text(
                            'Localin',
                            'This is my text to share with other applications.',
                            'text/plain');
                      },
                      child: Icon(Icons.share)),
                  SizedBox(
                    width: 10.0,
                  ),
                  state?.articleModel?.isBookmark == 0
                      ? InkWell(
                          onTap: () async {
                            final response = await state.bookmarkArticle();
                            if (response.error != null) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('${response?.error}'),
                              ));
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('${response?.message}'),
                              ));
                            }
                          },
                          child: Icon(Icons.bookmark_border))
                      : Icon(Icons.bookmark),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
