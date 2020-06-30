import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_detail/provider/community_detail_event_provider.dart';
import 'package:localin/presentation/community/community_detail/widget/single_upcoming_widget.dart';
import 'package:localin/presentation/community/community_event/widgets/single_community_event_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityDetailUpcomingEventsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityDetailEventProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<listEventState>(
            stream: provider.eventStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  provider.upcomingPageRequest <= 1) {
                return Container();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 20.0),
                      child: Text(
                        'UPCOMING EVENTS',
                        style: ThemeText.sfSemiBoldFootnote
                            .copyWith(color: ThemeColors.black80),
                      ),
                    ),
                    Container(
                      height: 250,
                      width: 270,
                      child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.upcomingList.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data == listEventState.empty) {
                            return Container();
                          } else if (index < provider.upcomingList.length) {
                            return Container(
                                width: 280,
                                height: 250,
                                child: SingleUpcomingWidget(
                                  event: provider.upcomingList[index],
                                  index: index,
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
                    )
                  ],
                );
              }
            });
      },
    );
  }
}
