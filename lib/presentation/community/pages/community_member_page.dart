import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/MemberListItem.dart';
import 'package:localin/model/community/community_member_detail.dart';
import 'package:localin/model/community/community_member_response.dart';

class CommunityMemberPage extends StatefulWidget {
  static const routeName = '/communityMemberPage';
  static const communityId = '/communityId';
  @override
  _CommunityMemberPageState createState() => _CommunityMemberPageState();
}

class _CommunityMemberPageState extends State<CommunityMemberPage> {
  Future member;

  Future<List<MemberListItem>> getMembers(String communityId) async {
    var response = await Repository().getCommunityMember(communityId);
    return mapperFromApi(response);
  }

  List<MemberListItem> mapperFromApi(CommunityMemberResponse detail) {
    var items = detail.data;
    List<AdminItem> adminItem = List();
    List<MemberItem> memberItem = List();
    List<MemberListItem> memberList = List();
    items.map((value) {
      if (value.status == 'admin') {
        adminItem.add(AdminItem(title: value.name));
      } else {
        memberItem.add(MemberItem(title: value.name));
      }
    }).toList();
    memberList.insert(0, HeadingItem(title: 'ADMIN'));
    memberList.addAll(adminItem);
    if (memberItem.isNotEmpty) {
      memberList.insert(memberList.length, HeadingItem(title: 'MEMBER'));
      memberList.addAll(memberItem);
    }
    return memberList;
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String communityId = routeArgs[CommunityMemberPage.communityId];
    return Scaffold(
        body: FutureBuilder<List<MemberListItem>>(
      future: getMembers(communityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final item = snapshot.data[index];
              if (item is HeadingItem) {
                return Text(item.title);
              } else if (item is AdminItem) {
                return Text(item.title);
              } else {
                return Text('MEMBER');
              }
            },
          );
        }
      },
    ));
  }
}
