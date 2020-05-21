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
                .createDraftArticle();
        CustomDialog.closeDialog(context);
        if (result > 0) {
          CustomToast.showCustomBookmarkToast(context, 'Article Drafted',
              width: MediaQuery.of(context).size.width * 0.6);
          Navigator.of(context).pop('draft');
        } else {
          CustomToast.showCustomBookmarkToast(context, 'error');
        }
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
        bottomNavigationBar: Consumer<CreateArticleProvider>(
          builder: (context, provider, child) {
            return InkWell(
              onTap: () async {
                if (provider.isShareButtonActive) {
                  CustomDialog.showCenteredLoadingDialog(context,
                      message: 'Loading');
                  final result = await Provider.of<CreateArticleProvider>(
                          context,
                          listen: false)
                      .createArticle(isDraft: false);
                  CustomDialog.closeDialog(context);
                  if (result.error == null) {
                    Navigator.of(context).pop('published');
                    CustomToast.showCustomBookmarkToast(
                        context, 'Article Published',
                        width: MediaQuery.of(context).size.width * 0.6,
                        icon: 'circle_checked_blue',
                        iconColor: null);
                  } else {
                    CustomToast.showCustomBookmarkToast(context, result.error,
                        width: MediaQuery.of(context).size.width * 0.6);
                  }
                } else {
                  CustomToast.showCustomToast(context, provider.dataChecker);
                }
              },
              child: Container(
                width: double.maxFinite,
                height: 48.0,
                color: provider.isShareButtonActive
                    ? ThemeColors.primaryBlue
                    : ThemeColors.black80,
                child: Center(
                  child: Text(
                    'Share',
                    textAlign: TextAlign.center,
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              ),
            );
          },
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
