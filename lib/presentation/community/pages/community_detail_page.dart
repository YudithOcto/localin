import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/widget/community_detail_comment_section.dart';
import 'package:localin/presentation/community/pages/community_member_page.dart';
import 'package:localin/provider/community/community_detail_provider.dart';
import 'package:localin/utils/image_helper.dart';
import 'package:provider/provider.dart';

class CommunityDetailPage extends StatefulWidget {
  static const routeName = 'CommunityDetailPage';
  static const communitySlug = '/communitySlug';

  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String slug = routeArgs[CommunityDetailPage.communitySlug];
    return ChangeNotifierProvider<CommunityDetailProvider>(
      create: (_) => CommunityDetailProvider(communitySlug: slug),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: CommunityDetailColumn(),
          ),
        ),
      ),
    );
  }
}

class CommunityDetailColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommunityDetailProvider>(context);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:
                    ImageHelper.addSubFixHttp(provider?.communityDetail?.cover),
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: double.infinity,
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  );
                },
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: size.height * 0.3,
                  color: Colors.grey,
                ),
                errorWidget: (context, url, child) => Container(
                  width: double.infinity,
                  height: size.height * 0.3,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                left: 20.0,
                top: 20.0,
                child: SafeArea(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop('refresh');
                    },
                    child: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          provider.isSearchMemberPage
              ? CommunityMemberPage(
                  communityId: provider?.communityDetail?.id,
                )
              : CommunityDetailCommentSection()
        ],
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) {
    var provider = Provider.of<CommunityDetailProvider>(context);
    provider.isSearchMemberPage
        ? provider.setSearchMemberPage(false)
        : Navigator.of(context).pop();
    return null;
  }
}
