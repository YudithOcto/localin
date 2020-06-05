import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_detail/widget/community_parent_comment_widget.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:localin/presentation/others_profile/widgets/empty_other_user_community_widget.dart';
import 'package:provider/provider.dart';

class CommunityCommentListWidget extends StatefulWidget {
  final String communityId;
  CommunityCommentListWidget({Key key, this.communityId}) : super(key: key);

  @override
  _CommunityCommentListWidgetState createState() =>
      _CommunityCommentListWidgetState();
}

class _CommunityCommentListWidgetState
    extends State<CommunityCommentListWidget> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<CommunityRetrieveCommentProvider>(context, listen: false)
          .getCommentList(communityId: widget.communityId);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityRetrieveCommentProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<communityCommentState>(
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting &&
                provider.page <= 1) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: ListView.builder(
                  primary: false,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.commentList.length + 1,
                  itemBuilder: (context, index) {
                    if (snapshot.data == communityCommentState.empty) {
                      return EmptyOtherUserCommunityWidget(
                        username: '',
                      );
                    } else if (index < provider.commentList.length) {
                      return CommunityParentCommentWidget(
                          index: index,
                          communityComment: provider.commentList[index]);
                    } else if (provider.canLoadMore) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container();
                    }
                  },
                ),
              );
            }
          },
        );
      },
    );
  }
}
