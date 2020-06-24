import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/empty_event.dart';
import 'package:localin/presentation/community/community_event/widgets/single_community_event_widget.dart';
import 'package:provider/provider.dart';

class CommunityListUpcomingEvents extends StatefulWidget {
  @override
  _CommunityListUpcomingEventsState createState() =>
      _CommunityListUpcomingEventsState();
}

class _CommunityListUpcomingEventsState
    extends State<CommunityListUpcomingEvents> {
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
    return Consumer<CommunityEventProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<eventState>(
          stream: provider.eventStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                provider.upcomingPageRequest <= 1) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: provider.upcomingList.length + 1,
                itemBuilder: (context, index) {
                  if (snapshot.data == eventState.empty) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.25),
                      alignment: FractionalOffset.center,
                      child: EmptyEvent(
                        text: 'This group doesn’t have any upcoming events',
                      ),
                    );
                  } else if (index < provider.upcomingList.length) {
                    return Container(
                        margin: EdgeInsets.only(top: index == 0 ? 29.0 : 21.0),
                        child: SingleCommunityEvent(
                          event: provider.upcomingList[index],
                        ));
                  } else if (provider.isUpcomingEventCanLoadMore) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          },
        );
      },
    );
  }
}
