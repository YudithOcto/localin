import 'package:flutter/material.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/pages/community_member_page.dart';
import 'package:localin/presentation/community/widget/community_comment_card.dart';
import 'package:localin/presentation/community/widget/community_description.dart';
import 'package:localin/presentation/community/widget/community_profile_form_input.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/community/community_detail_provider.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/star_display.dart';
import 'package:provider/provider.dart';

class CommunityDetailPage extends StatefulWidget {
  static const routeName = '/communityProfile';
  static const communityModel = '/communityModel';

  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    CommunityDetail detail = routeArgs[CommunityDetailPage.communityModel];
    return ChangeNotifierProvider<CommunityDetailProvider>(
      create: (_) => CommunityDetailProvider(communityDetail: detail),
      child: Scaffold(
        body: SingleChildScrollView(
          child: CommunityDetailColumn(),
        ),
      ),
    );
  }
}

class CommunityDetailColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommunityDetailProvider>(context);
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: provider?.communityDetail?.cover != null
                    ? DecorationImage(
                        image: NetworkImage(
                          '${provider?.communityDetail?.cover}',
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
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
            : CommunityDetailWithComments()
      ],
    );
  }
}

class CommunityDetailWithComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CommunityDescription(),
        Visibility(
          visible: true,
          child: Container(
            margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
            child: Row(
              children: <Widget>[
                StarDisplay(
                  value: 4.0,
                  size: 25.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  '4.5',
                  textAlign: TextAlign.center,
                  style: kValueStyle.copyWith(
                      color: Themes.primaryBlue, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: RoundedButtonFill(
                      onPressed: () {},
                      height: 30.0,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      title: 'Gabung Komunitas',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        CommunityFormInput(isVisible: true),
        SizedBox(
          height: 40.0,
          child: Divider(
            indent: 15.0,
            endIndent: 15.0,
            color: Colors.black54,
          ),
        ),
        Column(
          children: List.generate(2, (index) {
            return CommunityCommentCard(index: index);
          }),
        )
      ],
    );
  }
}
