import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/others_profile/widgets/others_profile_article_section_widget.dart';
import 'package:localin/presentation/profile/others_profile/widgets/others_profile_community_section_widget.dart';
import 'package:localin/presentation/profile/others_profile/widgets/revamp_others_profile_header_widget.dart';
import 'package:localin/presentation/profile/provider/revamp_others_provider.dart';
import 'package:provider/provider.dart';

class RevampOthersProfilePage extends StatelessWidget {
  static const routeName = '/otherProfilePage';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RevampOthersProvider>(
      create: (_) => RevampOthersProvider(),
      child: RevampOthersProfileContent(),
    );
  }
}

class RevampOthersProfileContent extends StatefulWidget {
  @override
  _RevampOthersProfileContentState createState() =>
      _RevampOthersProfileContentState();
}

class _RevampOthersProfileContentState
    extends State<RevampOthersProfileContent> {
  ScrollController _scrollController;
  bool isInit = true;

  _articleListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      Provider.of<RevampOthersProvider>(context, listen: false)
          .getArticleList(isRefresh: false);
    }
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      _scrollController = ScrollController();
      _scrollController..addListener(_articleListener);
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            RevampOthersProfileHeaderWidget(),
            OthersProfileCommunitySectionWidget(),
            OthersProfileArticleSectionWidget(),
          ],
        ),
      ),
    );
  }
}
