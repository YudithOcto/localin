import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/base_appbar.dart';
import 'package:localin/components/custom_header_below_base_appbar.dart';
import 'package:localin/provider/article/create_article_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CreateArticlePage extends StatefulWidget {
  static const routeName = '/createArticlePage';
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
    return Column(
      children: <Widget>[
        CustomHeaderBelowAppBar(
          title: 'Tulis Artikel',
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: state.titleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            hintText: 'Title',
            hintStyle: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Themes.lightGrey),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        dashBorderBig(context),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: state.contentController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            hintText: 'content',
            hintStyle: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Themes.lightGrey),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: TextFormField(
            enabled: false,
            controller: state.tagsController,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              hintText: 'tags',
              hintStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Themes.lightGrey),
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
            onPressed: () {},
            color: Themes.primaryBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            child: Text(
              'Save',
            ),
          ),
        )
      ],
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
                color: Themes.primaryBlue,
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
                color: Themes.primaryBlue,
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
