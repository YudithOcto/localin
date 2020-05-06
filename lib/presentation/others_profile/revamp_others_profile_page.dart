import 'package:flutter/material.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/presentation/article/shared_article_components/article_single_card.dart';
import 'package:localin/presentation/others_profile/widgets/others_profile_article_section_widget.dart';
import 'package:localin/presentation/others_profile/widgets/others_profile_community_section_widget.dart';
import 'package:localin/presentation/others_profile/widgets/revamp_others_profile_header_widget.dart';
import 'package:localin/presentation/others_profile/provider/revamp_others_provider.dart';
import 'package:provider/provider.dart';

class RevampOthersProfilePage extends StatelessWidget {
  static const routeName = '/otherProfilePage';
  static const userId = 'userId';
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String userId = routeArgs[RevampOthersProfilePage.userId];
    return ChangeNotifierProvider<RevampOthersProvider>(
      create: (_) => RevampOthersProvider(),
      child: RevampOthersProfileContent(
        userId: userId,
      ),
    );
  }
}

class RevampOthersProfileContent extends StatefulWidget {
  final String userId;
  RevampOthersProfileContent({this.userId});
  @override
  _RevampOthersProfileContentState createState() =>
      _RevampOthersProfileContentState();
}

class _RevampOthersProfileContentState
    extends State<RevampOthersProfileContent> {
  ScrollController _scrollController;
  bool isInit = true;
  Future getOtherUserProfile;

  _articleListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      Provider.of<RevampOthersProvider>(context, listen: false)
          .getArticleList(isRefresh: false, id: '${widget.userId}');
    }
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      _scrollController = ScrollController();
      _scrollController..addListener(_articleListener);
      getOtherUserProfile =
          Provider.of<RevampOthersProvider>(context, listen: false)
              .getOtherUserProfile('${widget.userId}');
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: FutureBuilder<UserModel>(
            future: getOtherUserProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.0),
                  children: <Widget>[
                    RevampOthersProfileHeaderWidget(
                      userModel: snapshot.data,
                    ),
                    Visibility(
                      visible: snapshot?.data?.type != kArticleMediaType,
                      child: OthersProfileCommunitySectionWidget(
                        userId: snapshot.data?.id,
                        username: snapshot.data?.username,
                      ),
                    ),
                    OthersProfileArticleSectionWidget(
                      id: snapshot.data?.id,
                      username: snapshot.data?.username,
                    ),
                  ],
                );
              } else {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Center(child: CircularProgressIndicator()));
              }
            }),
      ),
    );
  }
}
