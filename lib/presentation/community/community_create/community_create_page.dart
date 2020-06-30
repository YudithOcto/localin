import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/presentation/community/community_create/community_type_page.dart';
import 'package:localin/presentation/community/provider/create/community_create_provider.dart';
import 'package:localin/provider/core/image_picker_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

import 'widgets/community_add_category_widget.dart';
import 'widgets/community_add_description_widget.dart';
import 'widgets/community_add_location_widget.dart';
import 'widgets/community_add_picture_widget.dart';
import 'widgets/community_add_title_widget.dart';
import 'widgets/community_basic_info_widget.dart';

class CommunityCreatePage extends StatelessWidget {
  static const routeName = 'RevampCommunityCreatePage';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityCreateProvider>(
          create: (_) => CommunityCreateProvider(),
        ),
        ChangeNotifierProvider<ImagePickerProvider>(
          create: (_) => ImagePickerProvider(),
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
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          FocusScope.of(context).unfocus();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Create Community',
        appBar: AppBar(),
        onClickBackButton: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CommunityBasicInfoWidget(),
          CommunityAddPictureWidget(),
          CommunityAddTitleWidget(),
          CommunityAddDescriptionWidget(),
          CommunityAddCategoryWidget(),
          CommunityAddLocationWidget(),
        ],
      )),
      bottomNavigationBar: Consumer<CommunityCreateProvider>(
        builder: (context, provider, child) {
          return InkWell(
            onTap: () async {
              if (provider.isFormValid.isEmpty) {
                Navigator.of(context).pushNamed(CommunityTypePage.routeName,
                    arguments: {
                      CommunityTypePage.requestModel: provider.requestModel
                    });
              }
            },
            child: Consumer<CommunityCreateProvider>(
              builder: (context, provider, child) {
                return Container(
                  width: double.maxFinite,
                  height: 48.0,
                  color: provider.isFormValid.isEmpty
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
