import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_event_request_model.dart';
import 'package:localin/presentation/community/community_event/provider/community_create_event_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/community_create_event_wrapper.dart';
import 'package:provider/provider.dart';

class CommunityCreateEventPage extends StatelessWidget {
  static const routeName = 'CommunityCreateEventPage';
  static const communityData = 'CommunityData';
  static const previousEventModel = 'PreviousEventModel';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    CommunityDetail detail = routeArgs[CommunityCreateEventPage.communityData];
    CommunityEventRequestModel model =
        routeArgs[CommunityCreateEventPage.previousEventModel] ?? null;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityCreateEventProvider>(
          create: (_) => CommunityCreateEventProvider(detail.id, model: model),
        )
      ],
      child: CommunityCreateEventWrapper(),
    );
  }
}
