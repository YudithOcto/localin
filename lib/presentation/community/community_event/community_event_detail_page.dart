import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_detail_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_detail_botom_buton_widget.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_detail_wrapper_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityEventDetailPage extends StatelessWidget {
  static const routeName = 'CommunityEventDetailPage';
  static const eventSlug = 'eventSlug';
  static const communityData = 'communityData';
  static const backToHome = 'backToHome';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String eventId = routeArgs[CommunityEventDetailPage.eventSlug];
    bool backToHome = routeArgs[CommunityEventDetailPage.backToHome] ?? false;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityEventDetailProvider>(
          create: (_) => CommunityEventDetailProvider(eventId: eventId),
        )
      ],
      child: CommunityEventWrapperContent(
        isBackToHme: backToHome,
      ),
    );
  }
}

class CommunityEventWrapperContent extends StatelessWidget {
  final bool isBackToHme;

  CommunityEventWrapperContent({@required this.isBackToHme});

  @override
  Widget build(BuildContext context) {
    void _onBackPressed() {
      if (isBackToHme) {
        final routeArgs =
            ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        CommunityDetail detail =
            routeArgs[CommunityEventDetailPage.communityData];
        Navigator.of(context).pushNamedAndRemoveUntil(
            CommunityDetailPage.routeName, (route) => false,
            arguments: {
              CommunityDetailPage.communityData: detail,
              CommunityDetailPage.needBackToHome: true,
            });
      } else {
        Navigator.of(context).pop();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeColors.black10,
        appBar: CustomAppBar(
          appBar: AppBar(),
          pageTitle: 'Event Detail',
          titleStyle: ThemeText.sfMediumHeadline,
          leadingIcon: InkWell(
            onTap: _onBackPressed,
            child: Icon(
              Icons.arrow_back,
              color: ThemeColors.black80,
            ),
          ),
        ),
        bottomNavigationBar: CommunityEventDetailBottomButtonWidget(),
        body: StreamBuilder<eventDetailState>(
          stream:
              Provider.of<CommunityEventDetailProvider>(context, listen: false)
                  .streamEvent,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == eventDetailState.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data == eventDetailState.empty) {
                return Container(
                  alignment: FractionalOffset.center,
                  child: Text('Event Not Found'),
                );
              } else {
                return CommunityEventDetailWrapperWidget();
              }
            }
          },
        ),
      ),
    );
  }
}
