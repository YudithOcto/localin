import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/presentation/profile/provider/revamp_edit_profile_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import '../../../themes.dart';

class RevampEditProfilePage extends StatelessWidget {
  static const routeName = '/revampEditProfilePage';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RevampEditProfileProvider>(
      create: (_) => RevampEditProfileProvider(
          model: Provider.of<AuthProvider>(context, listen: false).userModel),
      child: RevampEditProfileWrapperWidget(),
    );
  }
}

GlobalKey<FormState> editProfileKey = GlobalKey<FormState>();

class RevampEditProfileWrapperWidget extends StatefulWidget {
  @override
  _RevampEditProfileWrapperWidgetState createState() =>
      _RevampEditProfileWrapperWidgetState();
}

class _RevampEditProfileWrapperWidgetState
    extends State<RevampEditProfileWrapperWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black0,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeColors.black0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: Text(
          'Edit profile',
          style: ThemeText.sfMediumHeadline,
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          final editProvider = Provider.of<RevampEditProfileProvider>(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Material(
                          clipBehavior: Clip.antiAlias,
                          shape: SuperellipseShape(
                            side: BorderSide(
                                color: ThemeColors.black20,
                                width: 8,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(48.0),
                          ),
                          child: editProvider.userImageFile == null
                              ? CachedNetworkImage(
                                  imageUrl: provider.userModel.imageProfile,
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      height: 62.0,
                                      width: 62.0,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )),
                                    );
                                  },
                                  placeholder: (context, placeHolder) =>
                                      Container(
                                    height: 62.0,
                                    width: 62.0,
                                    color: ThemeColors.black40,
                                  ),
                                  placeholderFadeInDuration:
                                      Duration(milliseconds: 250),
                                  errorWidget: (context, errorMsg, child) =>
                                      Container(
                                    height: 62.0,
                                    width: 62.0,
                                    color: ThemeColors.black40,
                                  ),
                                )
                              : Image.file(
                                  editProvider.userImageFile,
                                  width: 62.0,
                                  height: 62.0,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        RaisedButton(
                          elevation: 0.0,
                          color: ThemeColors.black0,
                          onPressed: () =>
                              showDialogImagePicker(editProvider, context),
                          child: Text(
                            'Change picture',
                            style: ThemeText.sfMediumFootnote
                                .copyWith(color: ThemeColors.primaryBlue),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: ThemeColors.black20),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'DISPLAY NAME',
                            style: ThemeText.rodinaBody
                                .copyWith(color: ThemeColors.black80),
                          ),
                          TextFormField(
                            style: ThemeText.sfRegularHeadline,
                            controller: editProvider.displayNameController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColors.black20, width: 1.5)),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColors.black20, width: 1.5)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'ABOUT NAME',
                            style: ThemeText.rodinaBody
                                .copyWith(color: ThemeColors.black80),
                          ),
                          TextFormField(
                            style: ThemeText.sfRegularHeadline,
                            controller: editProvider.shortBioController,
                            maxLines: null,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColors.black20, width: 1.5)),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeColors.black20, width: 1.5)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 48.0,
                child: RaisedButton(
                  color: ThemeColors.primaryBlue,
                  onPressed: () {
                    saveUserChanges(editProvider, provider);
                  },
                  child: Text(
                    'Save changes',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void showDialogImagePicker(
      RevampEditProfileProvider profileState, BuildContext context) async {
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
                  final result = await profileState.openGallery();
                  if (result.isEmpty) {
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
                  final result = await profileState.openCamera();
                  if (result.isEmpty) {
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

  void saveUserChanges(
      RevampEditProfileProvider editProvider, AuthProvider authProvider) async {
    FocusScope.of(context).requestFocus(FocusNode());

    CustomDialog.showLoadingDialog(context,
        message: 'Saving and Updating Your Profile');
    final result = await editProvider.saveAndUpdateUserProfile();
    if (result.contains('Success')) {
      final response = await editProvider.refreshUserProfileData();
      if (response != null) {
        authProvider.setUserModel(response);
      }
    }

    showToast('$result',
        context: context,
        position:
            StyledToastPosition(offset: 70.0, align: Alignment.bottomCenter),
        textStyle:
            ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.red80),
        backgroundColor: ThemeColors.red10);
    CustomDialog.closeDialog(context);
  }
}
