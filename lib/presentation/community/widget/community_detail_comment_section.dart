import 'package:flutter/material.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/presentation/community/widget/community_comment_card.dart';
import 'package:localin/presentation/community/widget/community_description.dart';
import 'package:localin/presentation/community/widget/community_profile_form_input.dart';
import 'package:localin/provider/community/community_detail_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class CommunityDetailCommentSection extends StatefulWidget {
  @override
  _CommunityDetailCommentSectionState createState() =>
      _CommunityDetailCommentSectionState();
}

class _CommunityDetailCommentSectionState
    extends State<CommunityDetailCommentSection> {
  Future comment;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<CommunityDetailProvider>(context, listen: false);
    comment = provider.getCommentList(provider?.communityDetail?.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommunityDetailProvider>(context);
    return Column(
      children: <Widget>[
        CommunityDescription(),
        Visibility(
          visible: true,
          child: Container(
            margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: ThemeColors.primaryBlue,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '${provider.communityDetail?.ranting ?? 0}',
                      textAlign: TextAlign.center,
                      style: kValueStyle.copyWith(
                          color: ThemeColors.primaryBlue,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Visibility(
                  visible: provider != null && provider.communityDetail != null
                      ? !provider.communityDetail.isJoin
                      : false,
                  child: InkWell(
                    onTap: () =>
                        provider.joinCommunity(provider?.communityDetail?.id),
                    child: Container(
                      decoration: BoxDecoration(
                          color: ThemeColors.primaryBlue,
                          borderRadius: BorderRadius.circular(4.0)),
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Gabung Komunitas',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        CommunityFormInput(
          onRefresh: () {
            setState(() {
              comment = provider.getCommentList(provider?.communityDetail?.id);
            });
          },
        ),
        SizedBox(
          height: 40.0,
          child: Divider(
            indent: 15.0,
            endIndent: 15.0,
            color: Colors.black54,
          ),
        ),
        FutureBuilder<CommunityCommentBaseResponse>(
            future: comment,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError || snapshot.data.error != null) {
                  return Center(
                    child: Text('Oh snap! an error occured on our side'),
                  );
                } else {
                  if (snapshot.data.data.length > 0) {
                    return Column(
                      children:
                          List.generate(snapshot?.data?.data?.length, (index) {
                        return CommunityCommentCard(
                            index: index,
                            commentDetail: snapshot?.data?.data[index]);
                      }),
                    );
                  } else {
                    return Container(
                        margin: EdgeInsets.only(top: 35.0),
                        child: Text(
                          'No Comments yet on this community page',
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w500),
                        ));
                  }
                }
              }
            })
      ],
    );
  }
}
