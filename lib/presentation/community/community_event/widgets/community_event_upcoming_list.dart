import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/empty_event.dart';
import 'package:localin/presentation/community/community_event/widgets/single_community_event_widget.dart';
import 'package:provider/provider.dart';

class CommunityEventUpcomingList extends StatefulWidget {
  @override
  _CommunityEventUpcomingListState createState() =>
      _CommunityEventUpcomingListState();
}

class _CommunityEventUpcomingListState extends State<CommunityEventUpcomingList>
    with AutomaticKeepAliveClientMixin {
  bool _isInit = true;
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _scrollController..addListener(_listener);
      loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  loadData({bool isRefresh = true}) async {
    final provider =
        Provider.of<CommunityEventProvider>(context, listen: false);
    provider.getUpcomingEvent(isRefresh: isRefresh);
  }

  _listener() {
    if (_scrollController.offset > _scrollController.position.maxScrollExtent) {
      loadData(isRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<CommunityEventProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<eventState>(
          stream: provider.eventStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                (provider.upcomingPageRequest <= 1 ||
                    provider.pastPageRequest <= 1)) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  loadData();
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: provider.upcomingList.length + 1,
                  itemBuilder: (context, index) {
                    if (snapshot.data == eventState.empty) {
                      return Container(
                        alignment: FractionalOffset.center,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.25),
                        child: EmptyEvent(
                          text: 'This group doesn’t have any upcoming events',
                        ),
                      );
                    } else if (index < provider.upcomingList.length) {
                      return Container(
                          margin:
                              EdgeInsets.only(top: index == 0 ? 29.0 : 21.0),
                          child: SingleCommunityEvent(
                            event: provider.upcomingList[index],
                            index: index,
                            isPastEvent: false,
                          ));
                    } else if (provider.isUpcomingEventCanLoadMore) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
