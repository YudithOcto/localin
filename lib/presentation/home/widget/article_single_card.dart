import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/image_helper.dart';

import '../../../themes.dart';

class ArticleSingleCard extends StatelessWidget {
  final ArticleDetail articleDetail;
  ArticleSingleCard(this.articleDetail);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          upperRow(),
          SizedBox(
            height: 15.0,
          ),
          bigImages(context),
          Row(
            children: List.generate(articleDetail?.tags?.length, (index) {
              return Text(
                '#${articleDetail?.tags[index]?.tagName}',
                style: kValueStyle.copyWith(fontSize: 10.0, color: Themes.red),
              );
            }),
          ),
          rowBottomIcon(context),
          Divider()
        ],
      ),
    );
  }

  Widget upperRow() {
    return Row(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: articleDetail?.authorImage,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              radius: 25.0,
              backgroundImage: imageProvider,
            );
          },
          errorWidget: (context, url, child) => CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          placeholder: (context, url) => CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
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
                    visible: articleDetail.tags != null &&
                        articleDetail.tags.isNotEmpty &&
                        articleDetail.tags.first.tagName.isNotEmpty,
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
                  Visibility(
                    visible: articleDetail.tags != null &&
                        articleDetail.tags.isNotEmpty,
                    child: SizedBox(
                      width: 5.0,
                    ),
                  ),
                  Text(
                    '${DateHelper.formatDateFromApi(articleDetail?.createdAt)}',
                    style: kValueStyle.copyWith(
                        fontSize: 11.0, color: Colors.black45),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget bigImages(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ArticleDetailPage.routeName, arguments: {
          ArticleDetailPage.articleDetailModel: articleDetail,
          ArticleDetailPage.commentPage: false,
        });
      },
      child: CachedNetworkImage(
        imageUrl: ImageHelper.addSubFixHttp(articleDetail?.image),
        placeholderFadeInDuration: Duration(milliseconds: 250),
        imageBuilder: (context, imageProvider) {
          return Container(
            width: double.infinity,
            height: 150.0,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4.0),
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          );
        },
        placeholder: (context, url) => Container(
          color: Colors.grey,
          width: double.infinity,
          height: 150.0,
        ),
        errorWidget: (_, url, child) => Container(
          width: double.infinity,
          height: 150.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget rowBottomIcon(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            Icons.favorite_border,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ArticleDetailPage.routeName, arguments: {
                ArticleDetailPage.articleDetailModel: articleDetail,
                ArticleDetailPage.commentPage: true,
              });
            },
            child: ImageIcon(
              ExactAssetImage('images/ic_chat.png'),
              color: Colors.black,
            ),
          ),
          InkWell(
            onTap: () {
              Share.text(
                  'Localin',
                  'This is my text to share with other applications.',
                  'text/plain');
            },
            child: Icon(
              Icons.share,
              color: Colors.grey,
            ),
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
