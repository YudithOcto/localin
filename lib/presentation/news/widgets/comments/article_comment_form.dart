import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/news/provider/comment_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ArticleCommentForm extends StatefulWidget {
  final ScrollController controller;

  ArticleCommentForm({this.controller});

  @override
  _ArticleCommentFormState createState() => _ArticleCommentFormState();
}

class _ArticleCommentFormState extends State<ArticleCommentForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Consumer<CommentProvider>(
          builder: (context, provider, child) {
            return Visibility(
              visible: provider.commentClickedItem != null,
              child: Container(
                color: ThemeColors.black10,
                height: 37.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Reply to ${provider.commentClickedItem?.sender}',
                      style: ThemeText.sfRegularFootnote
                          .copyWith(color: ThemeColors.black80),
                    ),
                    InkWell(
                        onTap: () {
                          provider.setReplyToOtherUserCommentModel(null);
                          provider.commentController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        child: SvgPicture.asset('images/clear_icon.svg')),
                  ],
                ),
              ),
            );
          },
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
                  controller:
                      Provider.of<CommentProvider>(context).commentController,
                  focusNode:
                      Provider.of<CommentProvider>(context).messageFocusNode,
                  onChanged: (v) => {
                    if (v.isEmpty)
                      Provider.of<CommentProvider>(context, listen: false)
                          .textIsEmpty = true
                    else
                      Provider.of<CommentProvider>(context, listen: false)
                          .textIsEmpty = false
                  },
                  decoration: InputDecoration(
                      hintText: 'Input your message',
                      hintStyle: ThemeText.sfRegularBody
                          .copyWith(color: ThemeColors.black80),
                      border: InputBorder.none),
                ),
              ),
              Consumer<CommentProvider>(
                builder: (context, provider, child) {
                  return InkWell(
                      onTap: () async {
                        if (provider.commentController.text.isEmpty) {
                          return;
                        }
                        CustomDialog.showLoadingDialog(context,
                            message: 'please wait');
                        if (provider.commentClickedItem != null) {
                          await provider.replyOthersComment().then((value) {
                            closeCurrentLoading();
                            CustomToast.showCustomBookmarkToast(context, value);
                          });
                          provider.setReplyToOtherUserCommentModel(null,
                              isNeedRequestFocus: false);
                        } else {
                          await provider.publishComment().then((value) {
                            closeCurrentLoading(scrollToBottom: true);
                            CustomToast.showCustomBookmarkToast(context, value);
                          });
                        }
                      },
                      child: SvgPicture.asset(
                          'images/${provider.isTextEmpty ? 'send' : 'send_active'}.svg'));
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  closeCurrentLoading({bool scrollToBottom = false}) {
    CustomDialog.closeDialog(context);
    Future.delayed(Duration(milliseconds: 400), () {
      FocusScope.of(context).unfocus();
      if (scrollToBottom) {
        widget.controller.jumpTo(widget.controller.position.maxScrollExtent);
      }
    });
  }
}
