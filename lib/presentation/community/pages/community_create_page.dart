import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/presentation/community/provider/community_category_provider.dart';
import 'package:localin/presentation/community/provider/community_create_provider.dart';
import 'package:localin/presentation/community/widgets/create_community/community_add_category_widget.dart';
import 'package:localin/presentation/community/widgets/create_community/community_add_description_widget.dart';
import 'package:localin/presentation/community/widgets/create_community/community_add_location_widget.dart';
import 'package:localin/presentation/community/widgets/create_community/community_add_title_widget.dart';
import 'package:localin/presentation/community/widgets/create_community/community_basic_info_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityCreatePage extends StatelessWidget {
  static const routeName = 'RevampCommunityCreatePage';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityCreateProvider>(
          create: (_) => CommunityCreateProvider(),
        ),
        ChangeNotifierProvider<CommunityCategoryProvider>(
          create: (_) => CommunityCategoryProvider(),
        )
      ],
      child: CommunityCreateWrapperWidget(),
    );
  }
}

class CommunityCreateWrapperWidget extends StatefulWidget {
  @override
  _CommunityCreateWrapperWidgetState createState() =>
      _CommunityCreateWrapperWidgetState();
}

class _CommunityCreateWrapperWidgetState
    extends State<CommunityCreateWrapperWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Create Community',
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CommunityBasicInfoWidget(),
          CommunityAddLocationWidget(),
          CommunityAddTitleWidget(),
          CommunityAddDescriptionWidget(),
          CommunityAddCategoryWidget(),
        ],
      )),
      bottomNavigationBar: Consumer<CommunityCreateProvider>(
        builder: (context, provider, child) {
          return InkWell(
            onTap: () async {
//              if (provider.isContinueButtonActive) {
//                CustomDialog.showCenteredLoadingDialog(context,
//                    message: 'Loading');
//                final result = await Provider.of<CommunityCreateProvider>(
//                        context,
//                        listen: false)
//                    .createArticle(isDraft: false);
//                CustomDialog.closeDialog(context);
//                if (result.error == null) {
//                  Navigator.of(context).pop('published');
//                  CustomToast.showCustomBookmarkToast(
//                      context, 'Article Published',
//                      width: MediaQuery.of(context).size.width * 0.6,
//                      icon: 'circle_checked_blue',
//                      iconColor: null);
//                } else {
//                  CustomToast.showCustomBookmarkToast(context, result.error,
//                      width: MediaQuery.of(context).size.width * 0.6);
//                }
//              } else {
//                CustomToast.showCustomToast(context, provider.dataChecker);
//              }
            },
            child: Container(
              width: double.maxFinite,
              height: 48.0,
              color: provider.isContinueButtonActive
                  ? ThemeColors.primaryBlue
                  : ThemeColors.black80,
              child: Center(
                child: Text(
                  'Continue',
                  textAlign: TextAlign.center,
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.black0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
