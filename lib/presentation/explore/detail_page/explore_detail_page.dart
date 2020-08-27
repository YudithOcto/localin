import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/detail_page/provider/explore_event_detail_provider.dart';
import 'package:localin/presentation/explore/detail_page/widgets/bottom_navigation_explore_detail_widget.dart';
import 'package:localin/presentation/explore/detail_page/widgets/explore_detail_big_images_widget.dart';
import 'package:localin/presentation/explore/detail_page/widgets/explore_detail_description_widget.dart';
import 'package:localin/presentation/explore/detail_page/widgets/explore_detail_event_hours_widget.dart';
import 'package:localin/presentation/explore/detail_page/widgets/explore_detail_location_widget.dart';
import 'package:provider/provider.dart';

class ExploreDetailPage extends StatelessWidget {
  static const routeName = 'ExploreDetailPage';
  static const exploreId = 'ExploreEventID';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExploreEventDetailProvider>(
      create: (_) => ExploreEventDetailProvider(),
      child: ExploreDetailWrapperContent(),
    );
  }
}

class ExploreDetailWrapperContent extends StatefulWidget {
  @override
  _ExploreDetailWrapperContentState createState() =>
      _ExploreDetailWrapperContentState();
}

class _ExploreDetailWrapperContentState
    extends State<ExploreDetailWrapperContent> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      int id = routeArgs[ExploreDetailPage.exploreId];
      Provider.of<ExploreEventDetailProvider>(context, listen: false)
          .getEventDetail(id);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationExploreDetailWidget(),
      body: StreamBuilder<eventDetailState>(
          stream:
              Provider.of<ExploreEventDetailProvider>(context, listen: false)
                  .stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ExploreDetailBigImagesWidget(),
                  ExploreDetailDescriptionWidget(),
                  ExploreDetailEventHoursWidget(),
                  ExploreDetailLocationWidget(),
                ],
              ),
            );
          }),
    );
  }
}
