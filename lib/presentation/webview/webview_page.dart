import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:localin/build_environment.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

const String SUCCESS_VERIFICATION =
    'Pembayaran sukses dan sedang di verifikasi';

class WebViewPage extends StatefulWidget {
  static const routeName = 'DanaWebviewPage';
  static const urlName = 'webUrl';
  static const title = 'title';
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

//  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
//  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url
              .startsWith('${buildEnvironment.baseApiUrl}payment/dana/auth')) {
            Navigator.of(context).pop('success');
            flutterWebviewPlugin.close();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String url = routeArgs[WebViewPage.urlName];
    String title = routeArgs[WebViewPage.title] ?? '';
    //url = url.contains('https') ? url : url.replaceRange(0, 4, 'https');
    return WillPopScope(
      onWillPop: () async {
        if (await flutterWebviewPlugin.canGoBack()) {
          await flutterWebviewPlugin.goBack();
        } else {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        body: MaterialApp(
          routes: {
            '/': (_) => WebviewScaffold(
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
                        if (await flutterWebviewPlugin.canGoBack()) {
                          await flutterWebviewPlugin.goBack();
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
                  withJavascript: true,
                  javascriptChannels: Set.from([
                    JavascriptChannel(
                        name: 'Print',
                        onMessageReceived: (JavascriptMessage data) {
                          if (data.message.contains(SUCCESS_VERIFICATION)) {
                            Future.delayed(Duration(milliseconds: 2000), () {
                              Navigator.of(context).pop('${data.message}');
                              flutterWebviewPlugin.close();
                            });
                          }
                        }),
                  ]),
                  hidden: true,
                  withZoom: true,
                  url: url,
                  displayZoomControls: true,
                  withOverviewMode: true,
                  useWideViewPort: true,
                  //withLocalStorage: true,
                  // appCacheEnabled: true,
                ),
          },
        ),
      ),
    );
  }
}
