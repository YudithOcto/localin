import 'package:flutter/material.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/date_helper.dart';

import '../../../themes.dart';

class ArticleSingleCard extends StatelessWidget {
  final int index;
  final ArticleDetail articleDetail;
  ArticleSingleCard(this.index, this.articleDetail);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(ArticleDetailPage.routeName,
          arguments: {ArticleDetailPage.articleDetailModel: articleDetail}),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            upperRow(),
            bigImages(),
            Row(
              children: List.generate(articleDetail?.tags?.length, (index) {
                return Text(
                  '#${articleDetail?.tags[index]?.tagName}',
                  style:
                      kValueStyle.copyWith(fontSize: 10.0, color: Themes.red),
                );
              }),
            ),
            rowBottomIcon(),
            Divider()
          ],
        ),
      ),
    );
  }

  Widget upperRow() {
    return Row(
      children: <Widget>[
        articleDetail?.authorImage != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  articleDetail?.authorImage,
                ),
                radius: 25.0,
              )
            : CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage(
                  'images/article_icon.png',
                ),
              ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Text(
                  '${articleDetail?.title}',
                  overflow: TextOverflow.ellipsis,
                  style: kValueStyle,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  Visibility(
                    visible: articleDetail.tags.isNotEmpty,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Themes.green,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '${articleDetail.tags.isNotEmpty ? articleDetail?.tags?.first?.tagName : ''}',
                          style: kValueStyle.copyWith(
                              color: Colors.white, fontSize: 10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    '${DateHelper.formatDateFromApi(articleDetail?.createdAt)}',
                    style: kValueStyle.copyWith(
                        fontSize: 11.0, color: Colors.black45),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 5.0),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.black45,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget bigImages() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
          image: articleDetail?.image != null
              ? DecorationImage(
                  image: NetworkImage(articleDetail?.image), fit: BoxFit.cover)
              : null,
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8.0)),
      height: 150.0,
    );
  }

  Widget rowBottomIcon() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            Icons.favorite_border,
            color: Colors.grey,
          ),
          ImageIcon(
            ExactAssetImage('images/ic_chat.png'),
            color: Colors.black,
          ),
          Icon(
            Icons.share,
            color: Colors.grey,
          ),
          Icon(
            Icons.bookmark_border,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
