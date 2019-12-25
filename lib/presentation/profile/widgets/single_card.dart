import 'package:flutter/material.dart';
import 'package:localin/components/bottom_company_information.dart';
import 'package:localin/model/article/article_model.dart';
import 'package:localin/presentation/article/article_detail_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/date_helper.dart';

import '../../../themes.dart';
import 'header_profile.dart';

class SingleCard extends StatelessWidget {
  final int index;
  final List<ArticleModel> articleModel;
  SingleCard(this.index, this.articleModel);

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return HeaderProfile();
    } else if (index == articleModel.length - 1) {
      return BottomCompanyInformation();
    } else {
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: articleModel[index]?.image != null
                    ? Hero(
                        tag: articleModel[index].image,
                        child: Image.network(
                          articleModel[index].image,
                          fit: BoxFit.fitHeight,
                          height: 90.0,
                          width: 150.0,
                        ),
                      )
                    : Container(
                        width: 150.0,
                        height: 90.0,
                        color: Colors.grey,
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
                        Container(
                          constraints: BoxConstraints(maxWidth: 100.0),
                          decoration: BoxDecoration(
                              color: Themes.orange,
                              borderRadius: BorderRadius.circular(6.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            child: Text(
                              articleModel[index]?.tags[0]?.tagName ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: kValueStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  letterSpacing: -.5,
                                  fontWeight: FontWeight.w500),
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
}
