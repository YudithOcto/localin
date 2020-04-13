import 'package:flutter/material.dart';
import 'package:localin/components/bottom_company_information.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/profile/widgets/header_profile.dart';
import 'package:localin/presentation/profile/widgets/single_card.dart';
import 'package:localin/provider/profile/user_profile_detail_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

const kTitleStyle = TextStyle(
    fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w500);

const kValueStyle = TextStyle(
    fontSize: 14.0, color: Themes.black212121, fontWeight: FontWeight.w500);

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Content(),
    );
  }
}

class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  bool isInit = true;
  Future getUserArticle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      getUserArticle = Provider.of<UserProfileProvider>(context, listen: false)
          .getUserArticle();
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            child: ListView(
              children: <Widget>[
                HeaderProfile(),
                FutureBuilder<List<ArticleDetail>>(
                  future: getUserArticle,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData && snapshot.data.isEmpty) {
                        return Center(
                          child: Text(
                            'You have no article at the moment',
                            style: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.w500),
                          ),
                        );
                      }
                      return Consumer<UserProfileProvider>(
                        builder: (_, state, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: snapshot?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return SingleCard(index, snapshot?.data);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          BottomCompanyInformation(),
        ],
      ),
    );
  }
}
