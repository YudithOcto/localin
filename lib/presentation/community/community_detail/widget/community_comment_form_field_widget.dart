import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/community/provider/comment/community_publish_comment_provider.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityCommentFormFieldWidget extends StatelessWidget {
  final String communityId;
  CommunityCommentFormFieldWidget({this.communityId});
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityPublishCommentProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Visibility(
              visible: provider.currentClickedReplyData != null,
              child: Container(
                color: ThemeColors.black10,
                height: 37.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Reply to ${provider.currentClickedReplyData?.createdName}',
                      style: ThemeText.sfRegularFootnote
                          .copyWith(color: ThemeColors.black80),
                    ),
                    InkWell(
                        onTap: () {
                          provider.setReplyOthersCommentData(null);
                          provider.commentTextController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        child: SvgPicture.asset('images/clear_icon.svg')),
                  ],
                ),
              ),
            ),
            Container(
              color: ThemeColors.black0,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleImage(
                    height: 36.0,
                    width: 36.0,
                    imageUrl: Provider.of<AuthProvider>(context, listen: false)
                        .userModel
                        .imageProfile,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: provider.commentTextController,
                      focusNode: provider.formFocusNode,
                      onChanged: (v) => provider.emptyText = v.isEmpty,
                      decoration: InputDecoration(
                          hintText: 'Input your message',
                          hintStyle: ThemeText.sfRegularBody
                              .copyWith(color: ThemeColors.black80),
                          border: InputBorder.none),
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        if (provider.commentTextController.text.isEmpty) {
                          return;
                        }
                        final retrieveProvider =
                            Provider.of<CommunityRetrieveCommentProvider>(
                                context,
                                listen: false);
                        CustomDialog.showLoadingDialog(context,
                            message: 'please wait');
                        final result =
                            await provider.publishComment(communityId);
                        if (result.error == null) {
                          closeCurrentLoading(context);
                          CustomToast.showCustomBookmarkToast(
                              context, result.message);
                          if (provider.currentClickedReplyData != null) {
                            retrieveProvider
                                .addChildComment(result.commentResult);
                            retrieveProvider.setChildCommentDisplay(
                                true, int.parse(result.commentResult.parentId));
                          } else {
                            retrieveProvider
                                .addParentComment(result.commentResult);
                          }
                        } else {
                          closeCurrentLoading(context);
                          CustomToast.showCustomBookmarkToast(
                              context, result.error);
                        }
                        provider.setReplyOthersCommentData(null,
                            needFocus: false);
                      },
                      child: SvgPicture.asset(
                          'images/${provider.isTextEmpty ? 'send' : 'send_active'}.svg')),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  closeCurrentLoading(BuildContext context) {
    CustomDialog.closeDialog(context);
    FocusScope.of(context).unfocus();
  }
}
