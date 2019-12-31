import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/MemberListItem.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/provider/community/community_detail_provider.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class CommunityMemberPage extends StatefulWidget {
  final String communityId;

  CommunityMemberPage({this.communityId});

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
        memberItem.add(MemberItem(
            title: value.name,
            id: value.id,
            isApproved: value.isApproved,
            status: value.status));
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
  void initState() {
    super.initState();
    member = getMembers(widget.communityId);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommunityDetailProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
          child: Row(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    provider.setSearchMemberPage(false);
                  },
                  child: Icon(Icons.arrow_back)),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      hintText: 'Cari nama anggota . .',
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
            ],
          ),
        ),
        FutureBuilder<List<MemberListItem>>(
          future: member,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: FractionalOffset.center,
                margin: EdgeInsets.only(top: 20.0),
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data[index];
                    if (item is HeadingItem) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          item.title,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      );
                    } else if (item is AdminItem) {
                      return ListTile(
                        title: Text(item.title),
                        leading: CircleAvatar(
                          backgroundColor: Themes.silverGrey,
                          child: Icon(
                            Icons.people,
                            color: Themes.red,
                          ),
                        ),
                      );
                    } else {
                      var memberItem = item as MemberItem;
                      return ListTile(
                        title: Text(memberItem.title),
                        trailing: Icon(Icons.person_add),
                        leading: memberItem.isApproved == 0
                            ? CircleAvatar(
                                backgroundColor: Themes.silverGrey,
                                child: Icon(
                                  Icons.people,
                                  color: Themes.red,
                                ),
                              )
                            : Container(),
                      );
                    }
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
