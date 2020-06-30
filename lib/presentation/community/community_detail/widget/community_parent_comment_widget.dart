import 'package:flutter/material.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/presentation/community/community_detail/widget/community_child_comment_widget.dart';
import 'package:localin/presentation/community/provider/comment/community_publish_comment_provider.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

const NO_COMMENT = 'No';

class CommunityParentCommentWidget extends StatelessWidget {
  final CommunityComment communityComment;
  final int index;
  CommunityParentCommentWidget({this.communityComment, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      margin: EdgeInsets.only(top: index == 0 ? 0 : 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleImage(
                width: 40.0,
                height: 40.0,
                imageUrl: communityComment.createdAvatar ?? '',
                fit: BoxFit.cover,
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
                          '${communityComment.createdName ?? ''}',
                          style: ThemeText.sfMediumBody
                              .copyWith(color: ThemeColors.brandBlack),
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text(
                          '\u2022 ${DateHelper.timeAgo(DateTime.parse(communityComment.createdAt))}',
                          style: ThemeText.sfRegularFootnote
                              .copyWith(color: ThemeColors.black80),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${communityComment.commentContent.replaceAll('<br />', '\n')}',
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
                        Consumer<CommunityRetrieveCommentProvider>(
                          builder: (context, provider, child) {
                            return InkWell(
                              onTap: () {
                                final provider = Provider.of<
                                        CommunityRetrieveCommentProvider>(
                                    context,
                                    listen: false);
                                if (commentCountReply.contains(NO_COMMENT)) {
                                  return;
                                }
                                provider.setChildCommentDisplay(
                                    !provider.isShowChildComment(
                                        communityComment.id),
                                    communityComment.id);
                              },
                              child: Text(
                                '${provider.isShowChildComment(communityComment.id) ? 'Hide replies' : commentCountReply}',
                                style: ThemeText.sfMediumBody.copyWith(
                                    color:
                                        commentCountReply.contains(NO_COMMENT)
                                            ? ThemeColors.black80
                                            : ThemeColors.primaryBlue),
                              ),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            final provider =
                                Provider.of<CommunityPublishCommentProvider>(
                                    context,
                                    listen: false);
                            provider
                                .setReplyOthersCommentData(communityComment);
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
          Consumer<CommunityRetrieveCommentProvider>(
            builder: (context, provider, child) {
              return Visibility(
                visible: provider.isShowChildComment(communityComment.id),
                child: CommunityChildCommentWidget(
                  replayComment: communityComment.childCommentList,
                  totalComment: communityComment.childComment,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String get commentCountReply {
    if (communityComment.childComment == null ||
        communityComment.childComment == 0) {
      return 'No reply';
    } else {
      return '${communityComment.childComment} replies';
    }
  }
}
