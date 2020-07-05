import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_create/community_type_page.dart';
import 'package:localin/presentation/community/community_create/widgets/community_edit_type_only_widget.dart';
import 'package:localin/presentation/community/provider/create/category_list_provider.dart';
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
  static const previousCommunityData = 'PreviousCommunityData';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    CommunityDetail model = routeArgs != null
        ? routeArgs[CommunityCreatePage.previousCommunityData]
        : null;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityCreateProvider>(
          create: (_) => CommunityCreateProvider(),
        ),
        ChangeNotifierProvider<ImagePickerProvider>(
          create: (_) => ImagePickerProvider(),
        ),
        ChangeNotifierProvider<CategoryListProvider>(
          create: (_) => CategoryListProvider(),
        ),
      ],
      child: CommunityCreateWrapperWidget(model: model),
    );
  }
}

class CommunityCreateWrapperWidget extends StatefulWidget {
  final CommunityDetail model;
  CommunityCreateWrapperWidget({this.model});

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
    Future.delayed(Duration.zero, () {
      Provider.of<CommunityCreateProvider>(context, listen: false)
          .addPreviousData(widget.model);
    });
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
      body: StreamBuilder<createState>(
          stream: Provider.of<CommunityCreateProvider>(context, listen: false)
              .stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CommunityBasicInfoWidget(),
                CommunityAddPictureWidget(),
                CommunityAddTitleWidget(),
                CommunityAddDescriptionWidget(),
                Visibility(
                    visible: widget.model != null,
                    child: CommunityEditTypeOnlyWidget(
                      detail: widget.model,
                    )),
                CommunityAddCategoryWidget(
                    category: CommunityCategory(
                        categoryName: widget.model?.categoryName)),
                CommunityAddLocationWidget(),
              ],
            ));
          }),
      bottomNavigationBar: Consumer<CommunityCreateProvider>(
        builder: (context, provider, child) {
          return InkWell(
            onTap: () async {
              if (provider.isFormValid.isEmpty) {
                if (widget.model == null) {
                  Navigator.of(context).pushNamed(CommunityTypePage.routeName,
                      arguments: {
                        CommunityTypePage.requestModel: provider.requestModel
                      });
                } else {
                  CustomDialog.showLoadingDialog(context,
                      message: 'Loading ...');
                  final result = await provider.createEditCommunity(
                    model: provider.requestModel,
                  );
                  CustomDialog.closeDialog(context);
                  CustomToast.showCustomBookmarkToast(context, result?.message);
                  Navigator.of(context).pop('success');
                }
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
                      '${widget.model == null ? 'Continue' : 'Save Changes'}',
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
