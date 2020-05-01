import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:localin/presentation/profile/provider/revamp_verification_provider.dart';
import 'package:localin/provider/core/image_picker_provider.dart';
import 'package:provider/provider.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

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
                'NAME',
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
                                          provider.setSelectedCategory(provider
                                              .categoryList[index].category);
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '${provider.categoryList[index].category}',
                                              style: ThemeText.sfMediumHeadline,
                                            ),
                                            Radio(
                                              value: provider
                                                  .categoryList[index].category,
                                              activeColor: ThemeColors.black80,
                                              groupValue:
                                                  provider.selectedCategory,
                                              onChanged: (category) {
                                                provider.setSelectedCategory(
                                                    category);
                                                setState(() {
                                                  Navigator.of(context).pop();
                                                });
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
                  InkWell(
                    onTap: () {
                      showImagePickerDialog(context, provider);
                    },
                    child: TextFormField(
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
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Image Preferences',
                  style: ThemeText.sfMediumTitle3,
                ),
                SizedBox(height: 8.0),
                Text('Choose your preference to change your image',
                    style: ThemeText.sfMediumBody
                        .copyWith(color: ThemeColors.black80)),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        elevation: 1.0,
                        onPressed: () async {
                          final result = await imageProvider.openGallery();
                          if (result.isEmpty) {
                            provider.setUserFile(imageProvider.selectedImage);
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop(result);
                          }
                        },
                        color: ThemeColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          'Gallery',
                          style: ThemeText.rodinaTitle3
                              .copyWith(color: ThemeColors.black0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        elevation: 1.0,
                        color: ThemeColors.black0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(
                              color: ThemeColors.primaryBlue,
                            )),
                        onPressed: () async {
                          final result = await imageProvider.openCamera();
                          if (result.isEmpty) {
                            provider.setUserFile(imageProvider.selectedImage);
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop(result);
                          }
                        },
                        child: Text(
                          'Camera',
                          style: ThemeText.rodinaTitle3
                              .copyWith(color: ThemeColors.primaryBlue),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
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
