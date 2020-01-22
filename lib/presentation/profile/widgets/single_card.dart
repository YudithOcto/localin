import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/date_helper.dart';

import '../../../themes.dart';

class SingleCard extends StatelessWidget {
  final int index;
  final List<ArticleDetail> articleModel;
  SingleCard(this.index, this.articleModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            ArticleDetailPage.routeName,
            arguments: {
              ArticleDetailPage.articleDetailModel: articleModel[index]
            },
          );
        },
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: articleModel[index]?.image ?? '',
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 90.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover)),
                );
              },
              errorWidget: (context, url, child) => Container(
                color: Colors.grey,
                height: 90.0,
                width: 150.0,
                child: Icon(Icons.error),
              ),
              placeholder: (context, url) => Container(
                color: Colors.grey,
                height: 90.0,
                width: 150.0,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    articleModel[index].title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kValueStyle.copyWith(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: articleModel[index].tags != null &&
                            articleModel[index].tags.isNotEmpty,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 100.0),
                          decoration: BoxDecoration(
                              color: Themes.orange,
                              borderRadius: BorderRadius.circular(6.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            child: Text(
                              '${articleModel[index].tags != null && articleModel[index].tags.isNotEmpty ? articleModel[index]?.tags[0]?.tagName : ''}',
                              overflow: TextOverflow.ellipsis,
                              style: kValueStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  letterSpacing: -.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Text(
                          DateHelper.formatDateFromApi(
                                  articleModel[index].createdAt) ??
                              '',
                          style: kValueStyle.copyWith(
                              fontSize: 10.0, color: Colors.black54),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
