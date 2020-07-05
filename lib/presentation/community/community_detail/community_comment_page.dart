import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_detail/widget/community_comment_form_field_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/community_comment_list_widget.dart';
import 'package:localin/presentation/community/provider/comment/community_publish_comment_provider.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityCommentPage extends StatelessWidget {
  static const routeName = 'CommunityCommentPage';
  static const communityData = 'communityData';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityRetrieveCommentProvider>(
          create: (_) => CommunityRetrieveCommentProvider(),
        ),
        ChangeNotifierProvider<CommunityPublishCommentProvider>(
          create: (_) => CommunityPublishCommentProvider(),
        )
      ],
      child: CommunityCommentContent(),
    );
  }
}

class CommunityCommentContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    CommunityDetail _community = routeArgs[CommunityCommentPage.communityData];
    return Scaffold(
      backgroundColor: ThemeColors.greyDark,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        elevation: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        titleSpacing: 0.0,
        title: Text(
          'Comments',
          style: ThemeText.sfMediumHeadline,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CommunityCommentListWidget(
            communityId: _community.id,
          ),
          CommunityCommentFormFieldWidget(
            communityId: _community.id,
          ),
        ],
      ),
    );
  }
}
