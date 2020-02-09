import 'package:flutter/material.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/presentation/community/pages/community_create_edit_page.dart';
import 'package:localin/presentation/community/widget/community_card_widget.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/community/community_feed_provider.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class CommunityFeedPage extends StatefulWidget {
  @override
  _CommunityFeedPageState createState() => _CommunityFeedPageState();
}

class _CommunityFeedPageState extends State<CommunityFeedPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommunityFeedProvider>(
      create: (_) => CommunityFeedProvider(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5.0,
          backgroundColor: Theme.of(context).canvasColor,
          title: Image.asset(
            'images/app_bar_logo.png',
            width: MediaQuery.of(context).size.width * 0.3,
            height: 50.0,
          ),
        ),
        body: ScrollContent(),
      ),
    );
  }
}

class ScrollContent extends StatefulWidget {
  @override
  _ScrollContentState createState() => _ScrollContentState();
}

class _ScrollContentState extends State<ScrollContent> {
  bool isInit = true;
  Future communityFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
//      communityFuture =
//          Provider.of<CommunityFeedProvider>(context).getCommunityData();
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommunityFeedProvider>(context);
    return FutureBuilder(
      future: communityFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Loading Community Data',
                style: kValueStyle,
              ),
            ],
          ));
        } else {
          return ListView(
            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 16.0),
//                child: TextFormField(
//                  controller: provider.searchController,
//                  decoration: InputDecoration(
//                      border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(16.0)),
//                      prefixIcon: Icon(Icons.search),
//                      hintText: 'Cari Komunitas'),
//                ),
//              ),
//              Container(
//                height: 35.0,
//                margin: EdgeInsets.only(left: 5.0),
//                child: ListView.builder(
//                  scrollDirection: Axis.horizontal,
//                  itemCount: provider?.categoryList?.communityCategory != null
//                      ? provider.categoryList.communityCategory.length
//                      : 0,
//                  itemBuilder: (context, index) {
//                    return QuickMenuCommunity(
//                        index: index,
//                        category:
//                            provider.categoryList.communityCategory[index]);
//                  },
//                ),
//              ),
              provider.isSearchLoading
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 25.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'images/404_image.png',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                          ),
                        ),
                        Text(
                          '404',
                          style: kValueStyle.copyWith(
                              fontSize: 40.0, color: Themes.primaryBlue),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Oops. Page akan segera datang',
                          style: kValueStyle.copyWith(
                              fontSize: 20.0,
                              color: Themes.primaryBlue,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 35.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            'Kami akan berusaha membantu kamu mencari jalan keluar. Karena halaman ini belum tersedia',
                            textAlign: TextAlign.center,
                            style: kValueStyle.copyWith(
                                fontSize: 16.0,
                                color: Themes.primaryBlue,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
//              provider.isSearchLoading
//                  ? Center(
//                      child: Container(
//                          margin: EdgeInsets.only(top: 25.0),
//                          child: CircularProgressIndicator()),
//                    )
//                  : CommunityCardWidget(
//                      detailList: provider.communityDetail.communityDetailList,
//                    ),
//              CommunityBottomCard(),
            ],
          );
        }
      },
    );
  }
}

class QuickMenuCommunity extends StatelessWidget {
  final int index;
  final CommunityCategory category;
  QuickMenuCommunity({this.index, this.category});
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommunityFeedProvider>(context);
    return Container(
      margin: EdgeInsets.only(right: 5.0),
      child: ActionChip(
        backgroundColor: provider.currentQuickPicked == index
            ? Themes.greyGainsBoro
            : Themes.primaryBlue,
        onPressed: () {
          provider.setCurrentQuickPicked(index, category.id);
          if (index == 0) {
            provider.searchCommunity('');
          } else {
            provider.searchCommunityBaseCategory(category.id);
          }
        },
        label: Text(
          '${category?.categoryName}',
          style: kValueStyle.copyWith(
              fontSize: 11.0,
              color: provider.currentQuickPicked == index
                  ? Themes.primaryBlue
                  : Colors.white),
        ),
      ),
    );
  }
}

class CommunityBottomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RoundedClipper(),
      child: Container(
        color: Themes.primaryBlue,
        height: 350.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bangun Komunitas Kamu',
              style: kValueStyle.copyWith(fontSize: 14.0, color: Colors.white),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Sekarang Juga!',
              style: kValueStyle.copyWith(fontSize: 30.0, color: Colors.white),
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              elevation: 5.0,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CommunityCreateEditPage.routeName, arguments: {
                  CommunityCreateEditPage.isUpdatePage: false,
                });
              },
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Text(
                'Buat Komunitas',
                style: kValueStyle.copyWith(
                    fontSize: 14.0, color: Themes.primaryBlue),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    Path path = Path()
      ..moveTo(0.0, height * 0.3)
      ..quadraticBezierTo(width * 0.5, 0.0, width, size.height * 0.3)
      ..lineTo(width, height)
      ..lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
