import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/home/widget/articles/row_article.dart';
import 'package:localin/presentation/home/widget/community/row_community.dart';
import 'package:localin/presentation/home/widget/row_user_location.dart';

class HomeContentDefault extends StatefulWidget {
  final bool isHomePage;
  final ValueChanged<int> valueChanged;
  HomeContentDefault({this.isHomePage, this.valueChanged});

  @override
  _HomeContentDefaultState createState() => _HomeContentDefaultState();
}

class _HomeContentDefaultState extends State<HomeContentDefault> {
  @override
  void initState() {
    locator<AnalyticsService>().setScreenName(name: 'HomePage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 50.0),
      children: <Widget>[
        RowUserLocation(),
        RowCommunity(),
        SizedBox(
          height: 12.0,
        ),
        RowArticle(
          valueChanged: widget.valueChanged,
        )
      ],
    );
  }

  containerDivider(double verticalHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalHeight),
      color: Colors.black12.withOpacity(0.2),
      width: double.infinity,
      height: 1.0,
    );
  }
}
