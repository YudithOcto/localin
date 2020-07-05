import 'package:flutter/material.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/presentation/news/provider/comment_provider.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

class ChildCommentCard extends StatelessWidget {
  final List<ArticleCommentDetail> replayComment;
  ChildCommentCard({this.replayComment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: (40.0 + 11.0)),
      width: double.infinity,
      child: Column(
          children: List.generate(
        replayComment.length,
        (index) => Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0.0 : 28.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RevampOthersProfilePage.routeName, arguments: {
                    RevampOthersProfilePage.userId:
                        replayComment[index].createdBy,
                  });
                },
                child: CircleImage(
                  width: 40.0,
                  height: 40.0,
                  imageUrl: replayComment[index]?.senderAvatar ?? '',
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
                        Expanded(
                          child: Text(
                            '${replayComment[index]?.sender ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ThemeText.sfMediumBody
                                .copyWith(color: ThemeColors.brandBlack),
                          ),
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text(
                          '\u2022 ${DateHelper.timeAgo(DateTime.parse(replayComment[index]?.createdAt))}',
                          style: ThemeText.sfRegularFootnote
                              .copyWith(color: ThemeColors.black80),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    replayComment[index]?.comment != null
                        ? buildReplayComment(
                            context, replayComment[index]?.comment)
                        : Container(),
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
                    InkWell(
                      onTap: () =>
                          Provider.of<CommentProvider>(context, listen: false)
                              .setReplyToOtherUserCommentModel(
                                  replayComment[index]),
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Text(
                          'Reply',
                          style: ThemeText.sfSemiBoldBody
                              .copyWith(color: ThemeColors.brandBlack),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget buildReplayComment(BuildContext context, String message) {
    List<String> splitMessage = message.split(' ');
    String body = splitMessage.skip(1).map((e) => e).join(' ');
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: '@${splitMessage[0] ?? ''}',
            style: ThemeText.sfRegularBody
                .copyWith(color: ThemeColors.primaryBlue)),
        TextSpan(
            text: ' ${body ?? ''}',
            style: ThemeText.sfRegularBody
                .copyWith(color: ThemeColors.brandBlack)),
      ]),
    );
  }
}
