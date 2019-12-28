import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_base_response_category.dart';
import 'package:localin/model/community/community_category.dart';

class CommunityCategorySearch extends StatefulWidget {
  static const routeName = '/communityCategorySearch';
  @override
  _CommunityCategorySearchState createState() =>
      _CommunityCategorySearchState();
}

class _CommunityCategorySearchState extends State<CommunityCategorySearch> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final TextEditingController _filter = new TextEditingController();
  List<CommunityCategory> categoryList = new List();

  @override
  void initState() {
    super.initState();
    _filter.addListener(_onSearchChanged);
    getCommunityCategory('');
  }

  _onSearchChanged() {
    getCommunityCategory(_filter.text);
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: categoryList.isNotEmpty
            ? _buildList()
            : Center(child: CircularProgressIndicator()),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: TextFormField(
        controller: _filter,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search Category',
          hintStyle: TextStyle(fontSize: 16.0, color: Colors.white),
          border: InputBorder.none,
          suffix: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: categoryList == null ? 0 : categoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(categoryList[index].categoryName),
          onTap: () {
            Navigator.of(context).pop(categoryList[index]);
          },
        );
      },
    );
  }

  Future<CommunityBaseResponseCategory> getCommunityCategory(
      String search) async {
    var response = await Repository().getCategoryListCommunity(search);
    if (response != null) {
      setState(() {
        categoryList.clear();
        categoryList.addAll(response.communityCategory);
      });
    }
    return response;
  }
}
