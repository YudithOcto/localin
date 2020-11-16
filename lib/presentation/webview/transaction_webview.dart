import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';

import '../../build_environment.dart';

class TransactionWebView extends StatefulWidget {
  static const routeName = 'TransactionWebView';
  static const urlName = 'webUrl';
  static const title = 'title';

  @override
  _TransactionWebViewState createState() => _TransactionWebViewState();
}

class _TransactionWebViewState extends State<TransactionWebView> {
  bool _isInit = true;
  Future checkAmp;
  InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      String url = routeArgs[TransactionWebView.urlName];
      checkAmp = checkAmpUrl(url);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<String> checkAmpUrl(String url) async {
    final result = await Repository().getCheckedAmp(url);
    if (result.message.isEmpty) {
      if (result.ampUrls.first.cdnAmpUrl != null &&
          result.ampUrls.first.errorCode.isEmpty) {
        return result.ampUrls.first.cdnAmpUrl;
      } else if (result.ampUrls.first.originalUrl.isNotEmpty) {
        return result.ampUrls.first.originalUrl;
      } else {
        return url;
      }
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String title = routeArgs[TransactionWebView.title] ?? '';
    return FutureBuilder<String>(
      future: checkAmp,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ThemeColors.black0,
              elevation: 0,
              titleSpacing: 0.0,
              title: Container(
                margin: EdgeInsets.only(right: 80.0),
                child: Text(
                  title ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: ThemeText.sfMediumHeadline,
                ),
              ),
              leading: InkWell(
                onTap: () async {
                  if (await webView.canGoBack()) {
                    await webView.goBack();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Icon(
                  Icons.keyboard_backspace,
                  color: ThemeColors.black80,
                ),
              ),
            ),
            body: InAppWebView(
              initialUrl: snapshot.data,
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                debuggingEnabled: true,
              )),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStop: (controller, message) {
                if (message.startsWith(
                    '${buildEnvironment.baseApiUrl}payment/dana/auth')) {
                  Navigator.of(context).pop('success');
                } else if (message.contains('success')) {
                  Future.delayed(Duration(milliseconds: 2000), () {
                    Navigator.of(context).pop('$SUCCESS_VERIFICATION}');
                  });
                }
              },
            ),
          );
        }
      },
    );
  }
}
