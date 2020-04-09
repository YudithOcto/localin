import 'package:flutter/material.dart';
import 'package:localin/presentation/home/widget/article_single_card.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';

class RowArticle extends StatefulWidget {
  @override
  _RowArticleState createState() => _RowArticleState();
}

class _RowArticleState extends State<RowArticle> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      Provider.of<HomeProvider>(context, listen: false)
          .resetAndGetArticleList();
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15.0, top: 5.0),
          child: Text(
            'Yang Terjadi Di Sekitarmu',
            style: kValueStyle.copyWith(fontSize: 24.0),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Provider.of<HomeProvider>(context).isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  if (provider.articleDetail == null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'images/article_empty.jpeg',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Belum Ada Cerita yang dibagikan di Sekitarmu, Ayo Jadi Yang Pertama Berbagi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: provider.articleDetail != null &&
                              provider.articleDetail.isNotEmpty
                          ? provider.articleDetail.length + 1
                          : 0,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == provider.total) {
                          return Container();
                        } else if (provider.articleDetail.length == index) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ArticleSingleCard(
                            provider?.articleDetail[index]);
                      },
                    );
                  }
                },
              )
      ],
    );
  }
}
