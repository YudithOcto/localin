import 'package:flutter/material.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/presentation/community/provider/comment/community_publish_comment_provider.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

class CommunityChildCommentWidget extends StatefulWidget {
  final List<CommunityComment> replayComment;
  final int totalComment;

  CommunityChildCommentWidget({Key key, this.replayComment, this.totalComment})
      : super(key: key);

  @override
  _CommunityChildCommentWidgetState createState() =>
      _CommunityChildCommentWidgetState();
}

class _CommunityChildCommentWidgetState
    extends State<CommunityChildCommentWidget> {
  int _page = 2;
  List<CommunityComment> _communityComment = [];
  int _totalComment = 0;

  @override
  void didUpdateWidget(CommunityChildCommentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_communityComment.length < widget.replayComment.length) {
      _communityComment.insert(
          _communityComment.length, widget.replayComment.last);
      _totalComment = widget.totalComment;
    }
  }

  @override
  void initState() {
    _communityComment.addAll(widget.replayComment);
    _totalComment = widget.totalComment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: (40.0 + 11.0)),
      width: double.infinity,
      child: Column(
          children: List.generate(
        _communityComment.length,
        (index) => Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0.0 : 28.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleImage(
                width: 40.0,
                height: 40.0,
                imageUrl: _communityComment[index]?.createdAvatar ?? '',
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
                        Expanded(
                          child: Text(
                            '${_communityComment[index]?.createdName ?? ''}',
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
                          '\u2022 ${DateHelper.timeAgo(DateTime.parse(_communityComment[index]?.createdAt))}',
                          style: ThemeText.sfRegularFootnote
                              .copyWith(color: ThemeColors.black80),
                        )
                      ],
                    ),
                    buildReplayComment(
                        context, _communityComment[index]?.commentContent),
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
                            return Visibility(
                              visible: index == _communityComment.length - 1 &&
                                  _totalComment > _communityComment.length,
                              child: InkWell(
                                onTap: () async {
                                  final result =
                                      await provider.getChildCommentList(
                                    communityId:
                                        _communityComment[index].communityId,
                                    parentId: _communityComment[index].parentId,
                                    page: _page,
                                  );
                                  _communityComment.addAll(result);
                                  setState(() {});
                                },
                                child: Text(
                                  'Load ${_totalComment - _communityComment.length} more comments',
                                  style: ThemeText.sfMediumBody
                                      .copyWith(color: ThemeColors.primaryBlue),
                                ),
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
                            provider.setReplyOthersCommentData(
                                _communityComment[index]);
                          },
                          child: Align(
                            alignment: FractionalOffset.centerRight,
                            child: Text(
                              'Reply',
                              style: ThemeText.sfSemiBoldBody
                                  .copyWith(color: ThemeColors.brandBlack),
                            ),
                          ),
                        ),
                      ],
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
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 13.0),
      child: RichText(
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
      ),
    );
  }
}
