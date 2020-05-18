import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/news/provider/create_article_provider.dart';
import 'package:localin/presentation/news/widgets/create_article/article_add_caption_widget.dart';
import 'package:localin/presentation/news/widgets/create_article/article_add_location_widget.dart';
import 'package:localin/presentation/news/widgets/create_article/article_add_tag_widget.dart';
import 'package:localin/presentation/news/widgets/create_article/article_add_title_widget.dart';
import 'package:localin/presentation/shared_widgets/horizontal_gallery_list_selected_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CreateArticleWrapperWidget extends StatefulWidget {
  @override
  _CreateArticleWrapperWidgetState createState() =>
      _CreateArticleWrapperWidgetState();
}

class _CreateArticleWrapperWidgetState
    extends State<CreateArticleWrapperWidget> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }

  draftOrBack() async {
    if (Provider.of<CreateArticleProvider>(context, listen: false)
        .isNeedAskUserToSaveToDraft) {
      final result = await CustomDialog.showCustomDialogWithMultipleButton(
        context,
        isDismissible: false,
        title: 'Save as draft?',
        message: 'Drafts let you save article, so you can come back later',
        cancelText: 'Cancel',
        okText: 'Save draft',
        onCancel: () => Navigator.of(context).pop(false),
        okCallback: () => Navigator.of(context).pop(true),
      );

      if (result != null && !result) {
        Navigator.of(context).pop();
      } else {
        CustomDialog.showCenteredLoadingDialog(context, message: 'Loading');
        final result =
            await Provider.of<CreateArticleProvider>(context, listen: false)
                .createArticle(isDraft: true);
        if (result.error == null) {
          CustomToast.showCustomBookmarkToast(context, 'Article Drafted');
        } else {
          CustomToast.showCustomBookmarkToast(context, result.error);
        }
        CustomDialog.closeDialog(context);
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        draftOrBack();
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(),
          pageTitle: 'Create Article',
          onClickBackButton: () => draftOrBack(),
        ),
        bottomNavigationBar: InkWell(
          onTap: () async {
            CustomDialog.showCenteredLoadingDialog(context, message: 'Loading');
            final result =
                await Provider.of<CreateArticleProvider>(context, listen: false)
                    .createArticle(isDraft: false);
            if (result.error == null) {
              CustomToast.showCustomBookmarkToast(context, 'Article Drafted');
            } else {
              CustomToast.showCustomBookmarkToast(context, result.error);
            }
            CustomDialog.closeDialog(context);
          },
          child: Container(
            width: double.maxFinite,
            height: 48.0,
            color: ThemeColors.primaryBlue,
            child: Center(
              child: Text(
                'Share',
                textAlign: TextAlign.center,
                style:
                    ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HorizontalGalleryListSelectedWidget(),
                ArticleAddTitleWidget(),
                ArticleAddCaptionWidget(),
                ArticleAddTagWidget(controller: _scrollController),
                ArticleAddLocationWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
