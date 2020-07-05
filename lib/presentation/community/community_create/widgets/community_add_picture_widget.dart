import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/community/provider/create/community_create_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/provider/core/image_picker_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityAddPictureWidget extends StatefulWidget {
  @override
  _CommunityAddPictureWidgetState createState() =>
      _CommunityAddPictureWidgetState();
}

class _CommunityAddPictureWidgetState extends State<CommunityAddPictureWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Subtitle(
            title: 'Profile Picture',
          ),
          SizedBox(height: 12.0),
          Row(
            children: <Widget>[
              Consumer<CommunityCreateProvider>(
                  builder: (context, provider, child) {
                return UserProfileImageWidget(
                  imageFile: provider.selectedImage,
                );
              }),
              SizedBox(
                width: 16.0,
              ),
              InkWell(
                onTap: () => showDialogImagePicker(context),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ThemeColors.black20),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Change Picture',
                      style: ThemeText.sfMediumFootnote
                          .copyWith(color: ThemeColors.primaryBlue),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void showDialogImagePicker(BuildContext context) async {
    final provider = Provider.of<ImagePickerProvider>(context, listen: false);
    final createProvider =
        Provider.of<CommunityCreateProvider>(context, listen: false);
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
                          final result = await provider.openGallery();
                          if (result.isEmpty) {
                            createProvider.selectImage = provider.selectedImage;
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
                          final result = await provider.openCamera();
                          if (result.isEmpty) {
                            createProvider.selectImage = provider.selectedImage;
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
