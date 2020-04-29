import 'package:flutter/material.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/presentation/article/widget/recommended_card.dart';
import 'package:localin/provider/article/article_detail_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class ArticleCommentPage extends StatelessWidget {
  final int pageSize = 4;
  @override
  Widget build(BuildContext context) {
    final articleProvider =
        Provider.of<ArticleDetailProvider>(context, listen: false);
    articleProvider.getArticleComment(0, 10);
    return Column(
      children: <Widget>[
        StreamBuilder<List<ArticleCommentDetail>>(
          stream: articleProvider.commentStream,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (asyncSnapshot.data.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text('There is no comment yet'),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: asyncSnapshot?.data?.length,
                    itemBuilder: (context, index) {
                      return CommentCard(
                        commentDetail: asyncSnapshot?.data[index],
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
        Material(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: articleProvider.commentController,
                    decoration: InputDecoration(
                        hintText: 'Berikan Komentar', border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                InkWell(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    if (articleProvider.commentController.text.isNotEmpty) {
                      final result = await articleProvider.publishComment();
                      if (result != null) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('error'),
                                content: Text('$result'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    color: ThemeColors.primaryBlue,
                                    child: Text('Ok'),
                                  )
                                ],
                              );
                            });
                      }
                    }
                  },
                  child: Container(
                    height: 35.0,
                    width: 35.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: ThemeColors.primaryBlue),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 15.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(visible: false, child: RecommendedCard())
      ],
    );
  }
}

class CommentCard extends StatelessWidget {
  final ArticleCommentDetail commentDetail;

  CommentCard({this.commentDetail});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${commentDetail?.sender}',
                      style:
                          kValueStyle.copyWith(color: ThemeColors.primaryBlue),
                    ),
                    Text(
                      '${commentDetail?.createdAt}',
                      style: kValueStyle.copyWith(
                          fontSize: 10.0, color: Colors.black26),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '${commentDetail?.comment}',
              style: kValueStyle.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
