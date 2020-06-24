import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_event/provider/community_create_event_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/community_create_event_wrapper.dart';
import 'package:provider/provider.dart';

class CommunityCreateEventPage extends StatelessWidget {
  static const routeName = 'CommunityCreateEventPage';
  static const communityId = 'CommunityId';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String comId = routeArgs[CommunityCreateEventPage.communityId];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityCreateEventProvider>(
          create: (_) => CommunityCreateEventProvider(comId),
        )
      ],
      child: CommunityCreateEventWrapper(),
    );
  }
}
