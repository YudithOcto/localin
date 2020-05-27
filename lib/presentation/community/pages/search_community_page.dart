import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/presentation/community/provider/search_community_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SearchCommunity extends StatelessWidget {
  static const routeName = 'SearchCommunityPage';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchCommunityProvider>(
      create: (_) => SearchCommunityProvider(),
      child: SearchCommunityContentWidget(),
    );
  }
}

class SearchCommunityContentWidget extends StatefulWidget {
  @override
  _SearchCommunityContentWidgetState createState() =>
      _SearchCommunityContentWidgetState();
}

class _SearchCommunityContentWidgetState
    extends State<SearchCommunityContentWidget> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController..addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.offset > _scrollController.position.maxScrollExtent) {
      Provider.of<SearchCommunityProvider>(context, listen: false)
          .getSearchResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        titleSpacing: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: Container(
          height: 43.0,
          margin: EdgeInsets.only(right: 20.0),
          child: Consumer<SearchCommunityProvider>(
            builder: (context, provider, child) {
              return TextFormField(
                controller: provider.searchTextController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ThemeColors.black10,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(color: ThemeColors.black0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(color: ThemeColors.black0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(color: ThemeColors.black0)),
                  hintText: 'Search Community',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.black60),
                ),
              );
            },
          ),
        ),
      ),
      body: Consumer<SearchCommunityProvider>(
        builder: (context, provider, child) {
          return StreamBuilder<searchCommunityState>(
            stream: provider.streamSearch,
            builder: (context, snapshot) {
              if (snapshot.data == searchCommunityState.loading &&
                  provider.offset <= 1) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data == searchCommunityState.empty) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Can’t find community',
                            style: ThemeText.sfSemiBoldHeadline
                                .copyWith(color: ThemeColors.black80),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            'Dicover community from other location, or create your own community',
                            style: ThemeText.sfRegularBody
                                .copyWith(color: ThemeColors.black80),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 20.0),
                      physics: ClampingScrollPhysics(),
                      itemCount: provider.resultCommunityList.length + 1,
                      itemBuilder: (context, index) {
                        if (provider.resultCommunityList.isEmpty) {
                          return Container();
                        } else if (index <
                            provider.resultCommunityList.length) {
                          final detail = provider.resultCommunityList[index];
                          return ListTile(
                            leading: CustomImageRadius(
                              width: 48,
                              height: 48,
                              radius: 8.0,
                              imageUrl: detail.logoUrl,
                            ),
                            title: Text(
                              '${detail.name}',
                              style: ThemeText.rodinaHeadline
                                  .copyWith(color: ThemeColors.black100),
                            ),
                            subtitle: Text(
                              '${detail?.totalMember} members',
                              style: ThemeText.sfMediumFootnote
                                  .copyWith(color: ThemeColors.black80),
                            ),
                          );
                        } else if (provider.isCanLoadMore) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                } else {
                  return Container();
                }
              }
            },
          );
        },
      ),
    );
  }
}
