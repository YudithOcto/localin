import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_detail/widget/single_card_community_news_widget.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:provider/provider.dart';

import '../../../../text_themes.dart';
import '../../../../themes.dart';
import '../community_comment_page.dart';

class CommunityNewsActivityWidget extends StatefulWidget {
  final CommunityDetail communityDetail;
  CommunityNewsActivityWidget({@required this.communityDetail});

  @override
  _CommunityNewsActivityWidgetState createState() =>
      _CommunityNewsActivityWidgetState();
}

class _CommunityNewsActivityWidgetState
    extends State<CommunityNewsActivityWidget> {
  bool _isInit = true;
  CommunityDetail _communityDetail;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _communityDetail = widget.communityDetail;
      loadCommentData(true);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  loadCommentData(bool isRefresh) {
    Provider.of<CommunityRetrieveCommentProvider>(context, listen: false)
        .getCommentList(communityId: _communityDetail.id, isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityRetrieveCommentProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<communityCommentState>(
            stream: provider.commentListState,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100.0),
                  itemCount: provider.commentList.length + 1,
                  itemBuilder: (context, index) {
                    if (snapshot.data == communityCommentState.empty ||
                        (provider.commentList.isEmpty && provider.page <= 2)) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Column(
                          children: <Widget>[
                            SvgPicture.asset('images/empty_article.svg'),
                            SizedBox(
                              height: 18.0,
                            ),
                            Text(
                              'No Activity',
                              textAlign: TextAlign.center,
                              style: ThemeText.sfSemiBoldHeadline
                                  .copyWith(color: ThemeColors.black80),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              'Community don\'t have any recent activities',
                              textAlign: TextAlign.center,
                              style: ThemeText.sfRegularBody
                                  .copyWith(color: ThemeColors.black80),
                            ),
                          ],
                        ),
                      );
                    } else if (index < provider.commentList.length) {
                      return SingleCardCommunityNewsWidget(
                        commentData: provider.commentList[index],
                        communityDetail: _communityDetail,
                        index: index,
                        onCommentPressed: () async {
                          if (_communityDetail.joinStatus != 'View') {
                            CustomToast.showCustomBookmarkToast(context,
                                'You must be a member to comment a post',
                                duration: 1);
                            return;
                          }
                          Navigator.of(context).pushNamed(
                              CommunityCommentPage.routeName,
                              arguments: {
                                CommunityCommentPage.communityData:
                                    _communityDetail,
                              });
                        },
                      );
                    } else if (provider.canLoadMore) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              }
            });
      },
    );
  }
}
