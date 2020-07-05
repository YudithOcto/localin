import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/presentation/community/community_detail/provider/community_create_post_provider.dart';
import 'package:localin/presentation/community/community_detail/widget/community_add_captions_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/community_add_tag_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/horizontal_gallery_list_community_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatelessWidget {
  static const routeName = 'CreatePostPage';
  static const communityId = 'communityId';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommunityCreatePostProvider>(
      create: (_) => CommunityCreatePostProvider(),
      child: CreatePostContentWidget(),
    );
  }
}

class CreatePostContentWidget extends StatefulWidget {
  @override
  _CreatePostContentWidgetState createState() =>
      _CreatePostContentWidgetState();
}

class _CreatePostContentWidgetState extends State<CreatePostContentWidget> {
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(onChange: (bool visible) {
      if (!visible) {
        final provider = Provider.of<CommunityCreatePostProvider>(context);
        if (provider.searchTagController.text.isNotEmpty) {
          provider.addTags = provider.searchTagController.text;
          provider.searchTagController.clear();
          FocusScope.of(context).unfocus();
          provider.clearListTags();
        } else {
          Navigator.of(context).pop();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        onClickBackButton: () => Navigator.of(context).pop(),
        pageTitle: 'Create Post',
      ),
      bottomNavigationBar: Consumer<CommunityCreatePostProvider>(
        builder: (context, provider, child) {
          return InkWell(
            onTap: () async {
              if (provider.isButtonActive.isNotEmpty) {
                return;
              }
              final routeArgs = ModalRoute.of(context).settings.arguments
                  as Map<String, dynamic>;
              String commId = routeArgs[CreatePostPage.communityId];

              CustomDialog.showLoadingDialog(context, message: 'Please wait');
              final result = await provider.addPost(commId);
              CustomDialog.closeDialog(context);
              if (result.error == null) {
                final dialog = await CustomDialog.showCustomDialogWithButton(
                    context, 'Create Post', result.message,
                    btnText: 'Close');
                if (dialog == 'success') {
                  Navigator.of(context).pop('success');
                }
              } else {
                CustomDialog.showCustomDialogWithButton(
                    context, 'Create Post', result.message,
                    btnText: 'Close');
              }
            },
            child: Container(
              height: 48.0,
              color: provider.isButtonActive.isEmpty
                  ? ThemeColors.primaryBlue
                  : ThemeColors.black80,
              alignment: FractionalOffset.center,
              child: Text(
                'Share',
                style:
                    ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
              ),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              HorizontalGalleryListCommunityWidget(),
              CommunityAddCaptionsWidget(),
              CommunityAddTagWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
