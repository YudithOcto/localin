import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/presentation/community/community_create_edit_page.dart';
import 'package:localin/presentation/community/widget/community_category_search.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/community/community_createedit_provider.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class CommunityCreateEditForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    bool isUpdatePage = routeArgs[CommunityCreateEditPage.isUpdatePage];
    var provider = Provider.of<CommunityCreateEditProvider>(context);
    return Form(
      key: provider.formKey,
      autovalidate: provider.autoValidate,
      child: provider.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  title('Nama Komunitas'),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 50.0,
                    child: TextFormField(
                      controller: provider.communityNameController,
                      validator: (value) =>
                          value.isEmpty ? 'Nama Komunitas di butuhkan' : null,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 12.0, color: Colors.black45),
                          hintText: 'Beri nama komunitas anda',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  title('Kategori'),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: InkWell(
                      onTap: () async {
                        var result = await Navigator.of(context)
                            .pushNamed(CommunityCategorySearch.routeName);
                        if (result != null) {
                          provider.setCategory(result);
                        }
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: provider.categoryController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 12.0, color: Colors.black45),
                            hintText: 'Contoh: IT, Otomotif, Seni dsb',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  title('Deskripsi'),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 120.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black26)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: provider.descriptionController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 12.0, color: Colors.black45),
                            hintText:
                                'Deskripsikan komunitas anda untuk menjangkau pengikut'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      title('Logo (Max. 850 KB'),
                      Text(
                        '${provider.logoImageFile != null ? '${(provider.logoImageFile.lengthSync() / 1024).toStringAsFixed(2)} Kb' : ''}',
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.red),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  dashBorder(context),
                  SizedBox(
                    height: 15.0,
                  ),
                  title('Sampul'),
                  SizedBox(
                    height: 15.0,
                  ),
                  dashBorderBig(context),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    child: RoundedButtonFill(
                      onPressed: () async {
                        if (provider.validateInput()) {
                          var result =
                              await provider.createCommunity(isUpdatePage);
                          var dialog = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Community Create'),
                                  content: Text(
                                      '${result?.message != null ? result?.message : result?.error}'),
                                  actions: <Widget>[
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop('close');
                                      },
                                      color: Themes.primaryBlue,
                                      elevation: 5.0,
                                      child: Text('OK'),
                                    )
                                  ],
                                );
                              });
                          if (dialog == 'close') {
                            Navigator.of(context).pop();
                          }
                        } else {
                          if (provider.logoImageFile == null) {
                            showDialogValidate(
                                context, 'Logo image is required');
                          } else if (provider.coverImageFile == null) {
                            showDialogValidate(
                                context, 'cover image is required');
                          } else if (provider.logoImageFile.lengthSync() >
                              900000) {
                            showDialogValidate(context,
                                'Logo File too big. Please upload smaller');
                          } else if (provider.category == null) {
                            showDialogValidate(context, 'Category is required');
                          }
                        }
                      },
                      needCenter: true,
                      fontSize: 18.0,
                      title: isUpdatePage ? 'Simpan' : 'Buat Komunitas',
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
    );
  }

  showDialogValidate(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Community Create'),
            content: Text('$message'),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Themes.primaryBlue,
                elevation: 5.0,
                child: Text('OK'),
              )
            ],
          );
        });
  }

  Widget title(String value) {
    return Text(
      '$value',
      style: kValueStyle.copyWith(
          fontWeight: FontWeight.w500,
          color: Themes.primaryBlue,
          fontSize: 16.0),
    );
  }

  Widget dashBorderBig(BuildContext context) {
    var state = Provider.of<CommunityCreateEditProvider>(context);
    return InkWell(
      onTap: () {
        showDialogImagePicker(context, state, false);
      },
      child: Container(
        height: 180.0,
        width: double.infinity,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          dashPattern: <double>[5, 5],
          color: Colors.black26,
          padding: EdgeInsets.all(6),
          child: state.coverImageFile == null
              ? ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Center(
                    child: Icon(
                      Icons.photo_camera,
                      size: 50.0,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    state.coverImageFile,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  Widget dashBorder(BuildContext context) {
    var state = Provider.of<CommunityCreateEditProvider>(context);
    return InkWell(
      onTap: () {
        showDialogImagePicker(context, state, true);
      },
      child: Container(
        alignment: Alignment.center,
        child: state.logoImageFile == null
            ? DottedBorder(
                borderType: BorderType.RRect,
                dashPattern: <double>[5, 5],
                color: Colors.black26,
                radius: Radius.circular(12),
                padding: EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.photo_camera,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                        Text(
                          'Drop files here',
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.black38),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.only(top: 10.0),
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Themes.primaryBlue)),
                child: Image.file(state.logoImageFile),
              ),
      ),
    );
  }

  void showDialogImagePicker(BuildContext context,
      CommunityCreateEditProvider profileState, bool isIcon) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Community'),
            content: Text('Please choose 1 of your preferences'),
            actions: <Widget>[
              RaisedButton(
                color: Themes.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var request = await profileState.openGallery(isIcon);
                  if (request.isNotEmpty) {
                    print(request);
                  }
                },
                elevation: 5.0,
                child: Text(
                  'Image Gallery',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Themes.primaryBlue,
                onPressed: () async {
                  Navigator.of(context).pop();
                  var request = await profileState.openCamera(isIcon);
                  if (request.isEmpty) {
                    print(request);
                  }
                },
                elevation: 5.0,
                child: Text(
                  'Camera',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              )
            ],
          );
        });
  }
}
