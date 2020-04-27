import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:localin/presentation/profile/revamp/provider/revamp_verification_provider.dart';
import 'package:localin/presentation/profile/revamp/page/user_profile_verification/revamp_user_verification_page.dart';
import 'package:localin/provider/core/image_picker_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../text_themes.dart';
import '../../../../../themes.dart';

class RowUserProfileFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RevampVerificationProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'FIELD TITLE',
                style:
                    ThemeText.rodinaBody.copyWith(color: ThemeColors.black80),
              ),
              TextFormField(
                textInputAction: TextInputAction.done,
                style: ThemeText.sfRegularHeadline,
                controller: provider.titleController,
                maxLines: null,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: ThemeColors.black20, width: 1.5)),
                  disabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: ThemeColors.black20, width: 1.5)),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Text(
                'CATEGORY',
                style:
                    ThemeText.rodinaBody.copyWith(color: ThemeColors.black80),
              ),
              InkWell(
                onTap: () {
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      transitionDuration: const Duration(milliseconds: 150),
                      barrierColor: ThemeColors.brandBlack.withOpacity(0.8),
                      pageBuilder: (context, anim1, anim2) => StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    provider.categoryList.length,
                                    (index) {
                                      return InkWell(
                                        onTap: () {
                                          provider.setSelectedCategory(
                                              provider.categoryList[index]);
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '${provider.categoryList[index]}',
                                              style: ThemeText.sfMediumHeadline,
                                            ),
                                            Radio(
                                              value:
                                                  provider.categoryList[index],
                                              activeColor: ThemeColors.black80,
                                              groupValue:
                                                  provider.selectedCategory,
                                              onChanged: (category) {
                                                provider.setSelectedCategory(
                                                    category);
                                                setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ));
                },
                child: TextFormField(
                  enabled: false,
                  style: ThemeText.sfRegularHeadline,
                  controller: provider.categoryController,
                  maxLines: null,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: ThemeColors.black80,
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeColors.black20, width: 1.5)),
                    disabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeColors.black20, width: 1.5)),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Text(
                'ATTACH DOCUMENT',
                style:
                    ThemeText.rodinaBody.copyWith(color: ThemeColors.black80),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                'Please Attach your personal identity (KTP/SIM/Paspor/Akte Pendirian)',
                style: ThemeText.sfRegularFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
              SizedBox(
                height: 8.0,
              ),
              Stack(
                children: <Widget>[
                  TextFormField(
                    enabled: false,
                    style: ThemeText.sfRegularHeadline,
                    controller: provider.documentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeColors.black20, width: 1.5)),
                      disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeColors.black20, width: 1.5)),
                    ),
                  ),
                  Positioned(
                      bottom: 8.0,
                      right: 0.0,
                      child: InkWell(
                        onTap: () {
                          showImagePickerDialog(context, provider);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(color: ThemeColors.black20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Change File',
                              textAlign: TextAlign.center,
                              style: ThemeText.sfMediumFootnote
                                  .copyWith(color: ThemeColors.primaryBlue),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showImagePickerDialog(
      BuildContext context, RevampVerificationProvider provider) async {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final dialogResult = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              'Choose your preference to change your image',
              style: ThemeText.rodinaHeadline
                  .copyWith(color: ThemeColors.primaryBlue),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            actions: <Widget>[
              RaisedButton(
                color: ThemeColors.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () async {
                  final result = await imageProvider.openGallery();
                  if (result.isEmpty) {
                    provider.setUserFile(imageProvider.selectedImage);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop(result);
                  }
                },
                elevation: 5.0,
                child: Text(
                  'Image Gallery',
                  style: ThemeText.rodinaFootnote
                      .copyWith(color: ThemeColors.black0),
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: ThemeColors.primaryBlue,
                onPressed: () async {
                  final result = await imageProvider.openCamera();
                  if (result.isEmpty) {
                    provider.setUserFile(imageProvider.selectedImage);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop(result);
                  }
                },
                elevation: 5.0,
                child: Text(
                  'Camera',
                  style: ThemeText.rodinaFootnote
                      .copyWith(color: ThemeColors.black0),
                ),
              )
            ],
          );
        });
    if (dialogResult != null) {
      showToast('$dialogResult',
          context: context,
          position:
              StyledToastPosition(offset: 70.0, align: Alignment.bottomCenter),
          textStyle:
              ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.red80),
          backgroundColor: ThemeColors.red10);
    }
  }
}
