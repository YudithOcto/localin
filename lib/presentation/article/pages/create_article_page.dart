import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:localin/components/base_appbar.dart';
import 'package:localin/components/custom_header_below_base_appbar.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/provider/article/create_article_provider.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CreateArticlePage extends StatefulWidget {
  static const routeName = 'CreateArticlePages';
  @override
  _CreateArticlePageState createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateArticleProvider>(
      create: (_) => CreateArticleProvider(),
      child: Scaffold(
        appBar: BaseAppBar(
          appBar: AppBar(),
        ),
        body: ScrollContent(),
      ),
    );
  }
}

class ScrollContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CreateArticleProvider>(context);
    return SingleChildScrollView(
      child: Form(
        key: state.formKey,
        autovalidate: state.autoValidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomHeaderBelowAppBar(
              title: 'Tulis Artikel',
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: TextFormField(
                controller: state.titleController,
                validator: (value) =>
                    value.isEmpty ? 'Title is required' : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  hintText: 'Title',
                  hintStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.lightGrey),
                ),
              ),
            ),
            dashBorderBig(context),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: TextFormField(
                controller: state.contentController,
                validator: (value) =>
                    value.isEmpty ? 'Content is required' : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  hintText: 'content',
                  hintStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.lightGrey),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: InkWell(
                onTap: () async {
                  var result = await Navigator.of(context)
                      .pushNamed(GoogleMapFullScreen.routeName, arguments: {
                    GoogleMapFullScreen.targetLocation: null,
                  });
                  if (result != null && result is Address) {
                    state.locationController.text =
                        '${result.locality}, ${result.subAdminArea}';
                    state.setAddress(result);
                  }
                },
                child: TextFormField(
                  enabled: false,
                  validator: (value) =>
                      value.isEmpty ? 'location is required' : null,
                  controller: state.locationController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      hintStyle:
                          TextStyle(fontSize: 12.0, color: Colors.black45),
                      hintText: 'set lokasi',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextFormField(
                controller: state.tagsController,
                validator: (value) => value.isEmpty ? 'Tags is required' : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  hintText: 'tags',
                  hintStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.lightGrey),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              height: 40.0,
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: RaisedButton(
                onPressed: () async {
                  if (state.validateInput()) {
                    var response = await state.createArticle();
                    if (response.error != null) {
                      Navigator.of(context).pop('success');
                    } else {
                      showDialogValidate(context, response.error);
                    }
                  } else {
                    showDialogValidate(context, 'image is required');
                  }
                },
                color: ThemeColors.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                child: state.state == ViewState.Idle
                    ? Text(
                        'Save',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dashBorderBig(BuildContext context) {
    var state = Provider.of<CreateArticleProvider>(context);
    return InkWell(
      onTap: () {
        showDialogImagePicker(context, state, false);
      },
      child: Container(
        height: 180.0,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          dashPattern: <double>[5, 5],
          color: Colors.black26,
          padding: EdgeInsets.all(6),
          child: state.attachmentImage == null
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
                    state.attachmentImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
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
                color: ThemeColors.primaryBlue,
                elevation: 5.0,
                child: Text('OK'),
              )
            ],
          );
        });
  }

  void showDialogImagePicker(
      BuildContext context, CreateArticleProvider providerState, bool isIcon) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Community'),
            content: Text('Please choose 1 of your preferences'),
            actions: <Widget>[
              RaisedButton(
                color: ThemeColors.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var request = await providerState.getImageFromStorage();
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
                color: ThemeColors.primaryBlue,
                onPressed: () async {
                  Navigator.of(context).pop();
                  var request = await providerState.getImageFromCamera();
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
