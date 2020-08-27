import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/shared_widget/mini_user_public_profile.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/image_redirect.dart';
import 'news_body_tag_widget.dart';
import 'news_detail_related_widget.dart';

class NewsDetailBodyContentWidget extends StatefulWidget {
  final ArticleDetail articleDetail;
  final Widget youtubeWidget;
  NewsDetailBodyContentWidget({this.articleDetail, this.youtubeWidget});
  @override
  _NewsDetailBodyContentWidgetState createState() =>
      _NewsDetailBodyContentWidgetState();
}

class _NewsDetailBodyContentWidgetState
    extends State<NewsDetailBodyContentWidget> {
  int _currentSelected = 0;
  ArticleDetail _articleDetail;
  bool _isInit = true;
  List<Widget> imageSliders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _articleDetail = widget.articleDetail;
      List<MediaModel> image = List.generate(_articleDetail.image.length,
          (index) => _articleDetail.image[index]).toList();
      imageSliders = image
          .map((item) => InkWell(
                onTap: () {
                  List<String> images =
                      _articleDetail.image.map((v) => v.attachment).toList();
                  redirectImage(context, images);
                },
                child: CachedNetworkImage(
                  imageUrl: item.attachment ?? '',
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: 209.0,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )),
                    );
                  },
                  placeholder: (context, image) => Container(
                    height: 209.0,
                    width: double.maxFinite,
                    color: ThemeColors.black10,
                  ),
                  errorWidget: (context, image, child) => Container(
                    height: 209.0,
                    width: double.maxFinite,
                    color: ThemeColors.black10,
                  ),
                ),
              ))
          .toList();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
          child: Text(
            '${_articleDetail?.title ?? ''}',
            style: ThemeText.rodinaTitle3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 9.54, left: 20.0, right: 20.0),
          child: MiniUserPublicProfile(
            articleDetail: _articleDetail,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 9.54, bottom: 12.62, left: 20.0, right: 20.0),
          child: Text(
            '${DateHelper.formatNewsTimeFromString(_articleDetail.createdAt)} ${DateTime.now().timeZoneName}',
            style: ThemeText.sfRegularFootnote
                .copyWith(color: ThemeColors.black80),
          ),
        ),
        _articleDetail.type != kTypeVideo
            ? SizedBox(
                width: double.maxFinite,
                child: CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                      height: 209.0,
                      autoPlay: false,
                      enableInfiniteScroll:
                          imageSliders != null && imageSliders.length > 1,
                      enlargeCenterPage: false,
                      viewportFraction: 1.0,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSelected = index;
                        });
                      }),
                ),
              )
            : widget.youtubeWidget,
        Padding(
          padding: const EdgeInsets.only(top: 13.0, bottom: 19.0),
          child: imageSliders != null && imageSliders.length > 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imageSliders.map((url) {
                    int index = imageSliders.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentSelected == index
                            ? ThemeColors.primaryBlue
                            : ThemeColors.black60,
                      ),
                    );
                  }).toList(),
                )
              : Container(),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            '${_articleDetail?.description}',
            style:
                ThemeText.sfRegularBody.copyWith(color: ThemeColors.brandBlack),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 28.0),
          child: NewsBodyTagWidget(tagModel: _articleDetail?.tags),
        ),
        NewsDetailRelatedWidget(
          articleDetail: _articleDetail,
        ),
      ],
    );
  }
}
