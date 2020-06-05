import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/provider/community/community_detail_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../themes.dart';

class CommunityFormInput extends StatefulWidget {
  final Function onRefresh;

  CommunityFormInput({this.onRefresh});

  @override
  _CommunityFormInputState createState() => _CommunityFormInputState();
}

class _CommunityFormInputState extends State<CommunityFormInput> {
  double size = 50.0;
  VideoPlayerController _videoPlayerController;
  bool autoValidate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommunityDetailProvider>(context);
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  margin: EdgeInsets.only(right: size <= 50 ? 10.0 : 30.0),
                  duration: Duration(milliseconds: 500),
                  height: size,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  curve: Curves.easeInOut,
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          onTap: () {
                            if (size < 200.0) {
                              setState(() {
                                size = 200.0;
                              });
                            }
                          },
                          controller: provider.commentController,
                          validator: (value) =>
                              value.isEmpty ? 'Field is required' : null,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: InputBorder.none,
                              hintText: 'Tulis Sesuatu',
                              hintStyle: TextStyle(
                                fontSize: 12.0,
                              )),
                        ),
                        Expanded(
                          child: Visibility(
                            visible: size > 50.0,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Visibility(
                                    visible:
                                        provider.attachmentFileVideo != null,
                                    child: provider?.attachmentFileVideo !=
                                                null &&
                                            _videoPlayerController
                                                .value.initialized
                                        ? Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Container(
                                              width: 100.0,
                                              height: 60.0,
                                              child: VideoPlayer(
                                                  _videoPlayerController),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                  Visibility(
                                    visible:
                                        provider.attachmentFileImage != null,
                                    child: provider?.attachmentFileImage != null
                                        ? Container(
                                            width: 100.0,
                                            height: 60.0,
                                            child: Image.file(
                                                provider?.attachmentFileImage),
                                          )
                                        : Container(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  showDialogAttachment();
                                                },
                                                child: Icon(Icons.attach_file),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showDialogAttachment();
                                                },
                                                child: Text(
                                                  'Tambah Foto/Video',
                                                  textAlign: TextAlign.center,
                                                  style: kValueStyle.copyWith(
                                                      fontSize: 10.0,
                                                      color: Colors.black45),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: FlatButton(
                                              color: ThemeColors.primaryBlue,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0)),
                                              onPressed: () async {
                                                CommunityCommentBaseResponse
                                                    result = await provider
                                                        .postComment();
                                                if (result.error != null) {
                                                  showErrorDialog(result.error);
                                                } else {
                                                  widget.onRefresh();
                                                }
                                              },
                                              child: Text(
                                                'Kirim',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: size <= 50.0,
                child: Container(
                  margin: EdgeInsets.only(top: 15.0, right: 15.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        size = 200.0;
                      });
                      showDialogAttachment();
                    },
                    child: Icon(Icons.attach_file),
                  ),
                ),
              )
            ],
          ),
          provider.sendCommentLoading
              ? Align(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }

  void showDialogAttachment() async {
    var provider = Provider.of<CommunityDetailProvider>(context);
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Attachment'),
            content: Text('choose image or video'),
            actions: <Widget>[
              RaisedButton(
                onPressed: () async {
//                  var res = await provider.getImageFromStorage();
//                  if (res == null) {
//                    Navigator.of(context).pop('success');
//                  } else {
//                    Navigator.of(context).pop('$res');
//                  }
                },
                child: Text('Image'),
              ),
              RaisedButton(
                onPressed: () async {
//                  var res = await provider.getVideoFromStorage();
//                  if (res == null) {
//                    Navigator.of(context).pop('success');
//                  } else {
//                    Navigator.of(context).pop('$res');
//                  }
                },
                child: Text('Video'),
              )
            ],
          );
        });
    if (result == 'success') {
      _videoPlayerController =
          VideoPlayerController.file(provider.attachmentFileImage)
            ..initialize().then((_) {
              setState(() {});
            });
    } else {
      showErrorDialog(result);
    }
  }

  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('$message'),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: ThemeColors.primaryBlue,
                child: Text('OK'),
              )
            ],
          );
        });
  }
}
