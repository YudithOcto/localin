import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/presentation/home/widget/stay/gallery_photo_view.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';

class SingleCardCommunityNewsWidget extends StatelessWidget {
  final CommunityComment commentData;
  final VoidCallback onCommentPressed;
  SingleCardCommunityNewsWidget(
      {Key key, this.commentData, @required this.onCommentPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      margin: EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.only(
          top: 16.0, left: 20.0, right: 20.0, bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleImage(
                imageUrl: commentData?.createdAvatar,
                width: 36.0,
                height: 36.0,
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${commentData?.createdName}',
                      style: ThemeText.sfMediumBody,
                    ),
                    Text(
                      '${DateHelper.timeAgo(DateTime.parse(commentData?.createdAt))}',
                      style: ThemeText.sfMediumFootnote
                          .copyWith(color: ThemeColors.black80),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: false,
                child: Icon(
                  Icons.more_vert,
                  color: ThemeColors.black80,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              '${commentData.commentContent.replaceAll('<br />', '\n')}',
              style: ThemeText.sfRegularBody,
            ),
          ),
          Visibility(
            visible: commentData.attachment.isNotEmpty,
            child: InkWell(
              onTap: () {
                List<String> gallery = List();
                gallery.add(commentData.attachment.first.attachment);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryPhotoView(
                      galleryItems: gallery,
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      initialIndex: 0,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: CustomImageRadius(
                  imageUrl: commentData.attachment.isNotEmpty
                      ? commentData?.attachment?.first?.attachment ?? ''
                      : '',
                  width: double.maxFinite,
                  height: 200.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'images/ic_like_full.svg',
                            color: ThemeColors.black80,
                            width: 16.0,
                            height: 16.0,
                          ),
                          SizedBox(
                            width: 5.59,
                          ),
                          Text(
                            '0',
                            style: ThemeText.sfSemiBoldBody
                                .copyWith(color: ThemeColors.black80),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 9.67,
                    ),
                    InkWell(
                      onTap: onCommentPressed,
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'images/chat.svg',
                            width: 16.0,
                            height: 16.0,
                          ),
                          SizedBox(
                            width: 5.59,
                          ),
                          Text(
                            '${commentData.childCommentList.length}',
                            style: ThemeText.sfSemiBoldBody
                                .copyWith(color: ThemeColors.black80),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
