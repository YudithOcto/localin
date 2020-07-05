import 'package:flutter/material.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/presentation/news/provider/comment_provider.dart';
import 'package:localin/presentation/news/widgets/comments/child_comment_card.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

class ParentCommentCard extends StatefulWidget {
  final int index;
  final Function onFunction;
  final ArticleCommentDetail commentDetail;
  ParentCommentCard(
      {this.index, this.onFunction, @required this.commentDetail});

  @override
  _ParentCommentCardState createState() => _ParentCommentCardState();
}

class _ParentCommentCardState extends State<ParentCommentCard> {
  bool showReply = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RevampOthersProfilePage.routeName, arguments: {
                    RevampOthersProfilePage.userId:
                        widget.commentDetail.createdBy,
                  });
                },
                child: CircleImage(
                  width: 40.0,
                  height: 40.0,
                  imageUrl: widget.commentDetail?.senderAvatar ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 11.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '${widget.commentDetail.sender ?? ''}',
                          style: ThemeText.sfMediumBody
                              .copyWith(color: ThemeColors.brandBlack),
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text(
                          '\u2022 ${DateHelper.timeAgo(DateTime.parse(widget.commentDetail.createdAt))}',
                          style: ThemeText.sfRegularFootnote
                              .copyWith(color: ThemeColors.black80),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${widget.commentDetail.comment}',
                      style: ThemeText.sfRegularBody
                          .copyWith(color: ThemeColors.brandBlack),
                    ),
                    SizedBox(
                      height: 13.0,
                    ),
                    DashedLine(
                      color: ThemeColors.black20,
                      height: 1.5,
                    ),
                    SizedBox(
                      height: 9.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Consumer<CommentProvider>(
                          builder: (context, provider, child) {
                            return InkWell(
                              onTap: () {
                                if (!widget
                                    .commentDetail.replay.isNullOrEmpty) {
                                  setState(() {
                                    showReply = !showReply;
                                  });
                                }
                              },
                              child: Text(
                                '${showReply ? 'Hide' : widget.commentDetail?.replay?.length ?? 0} replies',
                                style: ThemeText.sfMediumBody
                                    .copyWith(color: ThemeColors.primaryBlue),
                              ),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            Provider.of<CommentProvider>(context, listen: false)
                                .setReplyToOtherUserCommentModel(
                                    widget.commentDetail);
                            if (!showReply) {
                              if (!widget.commentDetail.replay.isNullOrEmpty) {
                                setState(() {
                                  showReply = !showReply;
                                });
                              }
                            }
                          },
                          child: Text(
                            'Reply',
                            style: ThemeText.sfSemiBoldBody
                                .copyWith(color: ThemeColors.brandBlack),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 26.0,
          ),
          Visibility(
            visible: showReply,
            child: ChildCommentCard(
              replayComment: widget.commentDetail.replay,
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;
  const DashedLine(
      {this.height = 1, this.color = Colors.black, this.dashWidth = 5.0});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      final dashHeight = height;
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        children: List.generate(dashCount, (index) {
          return SizedBox(
            width: dashWidth,
            height: dashHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          );
        }),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        direction: Axis.horizontal,
      );
    });
  }
}

extension on List {
  bool get isNullOrEmpty {
    return this == null || this.isEmpty;
  }
}
