import 'package:flutter/material.dart';
import 'package:localin/provider/article/article_detail_provider.dart';
import 'package:provider/provider.dart';

class BannerArticle extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  BannerArticle({this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var state = Provider.of<ArticleDetailProvider>(context);
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          child: state?.articleModel?.image != null
              ? Hero(
                  tag: state.articleModel.image,
                  child: Image.network(
                    state.articleModel.image,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
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
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 0.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
