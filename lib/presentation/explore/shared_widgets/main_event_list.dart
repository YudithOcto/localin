import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/providers/explore_main_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/single_explore_card_widget.dart';
import 'package:localin/presentation/search/search_event/empty_event.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class MainEventList extends StatefulWidget {
  @override
  _MainEventListState createState() => _MainEventListState();
}

class _MainEventListState extends State<MainEventList> {
  bool _isInit = true;
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ExploreMainProvider>(context, listen: false)
          .getEventList(isRefresh: true);
      _scrollController
        ..addListener(() {
          if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent) {
            Provider.of<ExploreMainProvider>(context, listen: false)
                .getEventList(isRefresh: false);
          }
        });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: MediaQuery.of(context).size.height,
      color: ThemeColors.black0,
      child: Consumer<ExploreMainProvider>(
        builder: (context, provider, _) {
          return StreamBuilder<exploreState>(
              stream: provider.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    provider.pageOffset <= 1) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  physics: ClampingScrollPhysics(),
                  itemCount: provider.eventList.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Event and Attraction',
                              style: ThemeText.rodinaTitle2),
                          Consumer<LocationProvider>(
                            builder: (_, provider, __) {
                              return Text(
                                '${provider.address}',
                                style: ThemeText.sfMediumBody
                                    .copyWith(color: ThemeColors.black80),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      if (snapshot.data == exploreState.empty) {
                        return Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.15),
                            child: EmptyExploreEvent());
                      } else if (index - 1 < provider.eventList.length) {
                        return SingleExploreCardWidget(
                          detail: provider.eventList[index - 1],
                        );
                      } else if (provider.canLoadMore) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container();
                      }
                    }
                  },
                );
              });
        },
      ),
    );
  }
}
