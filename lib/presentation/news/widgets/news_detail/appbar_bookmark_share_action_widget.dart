import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/shared_widgets/article_single_card.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/themes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class AppBarBookMarkShareActionWidget extends StatefulWidget {
  final ArticleDetail articleDetail;
  final ValueChanged<bool> valueChanged;

  AppBarBookMarkShareActionWidget({this.articleDetail, this.valueChanged});

  @override
  _AppBarBookMarkShareActionWidgetState createState() =>
      _AppBarBookMarkShareActionWidgetState();
}

class _AppBarBookMarkShareActionWidgetState
    extends State<AppBarBookMarkShareActionWidget> {
  ArticleDetail _articleDetail;

  @override
  void initState() {
    super.initState();
    _articleDetail = widget.articleDetail;
  }

  @override
  void didUpdateWidget(AppBarBookMarkShareActionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _articleDetail = widget.articleDetail;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      margin: EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () async {
                final response = await Provider.of<HomeProvider>(context)
                    .bookmarkArticle(_articleDetail?.id);
                if (widget.valueChanged != null) {
                  widget.valueChanged(true);
                }
                if (response.error != null) {
                  CustomToast.showCustomToast(context, response.error);
                } else {
                  if (_articleDetail?.isBookmark == 1) {
                    unBookmarkArticle();
                  } else {
                    bookMarkArticle();
                  }
                }
              },
              child: SvgPicture.asset(
                _articleDetail?.isBookmark == 0
                    ? 'images/bookmark_outline.svg'
                    : 'images/bookmark_full.svg',
                color: _articleDetail?.isBookmark == 1
                    ? ThemeColors.primaryBlue
                    : null,
              )),
          Visibility(
            visible: _articleDetail?.type == kArticleMediaType,
            child: SizedBox(
              width: 10.0,
            ),
          ),
          Visibility(
            visible: _articleDetail?.type == kArticleMediaType,
            child: InkWell(
                onTap: () {
                  Share.text(
                      'Localin', '${_articleDetail?.slug}', 'text/plain');
                },
                child: SvgPicture.asset('images/share_article.svg')),
          ),
        ],
      ),
    );
  }

  bookMarkArticle() {
    setState(() {
      _articleDetail?.isBookmark = 1;
    });
    CustomToast.showCustomBookmarkToast(context, 'Added to Bookmark',
        undoCallback: () async {
      dismissAllToast(showAnim: true);
      await Provider.of<HomeProvider>(context)
          .bookmarkArticle(_articleDetail?.id);
      setState(() {
        _articleDetail?.isBookmark = 0;
      });
    });
  }

  unBookmarkArticle() {
    setState(() {
      _articleDetail?.isBookmark = 0;
    });
    CustomToast.showCustomBookmarkToast(context, 'Delete from bookmark',
        undoCallback: () async {
      dismissAllToast(showAnim: true);
      await Provider.of<HomeProvider>(context)
          .bookmarkArticle(_articleDetail?.id);
      setState(() {
        _articleDetail?.isBookmark = 1;
      });
    });
  }
}
