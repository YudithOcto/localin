import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:localin/build_environment.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class WebViewPage extends StatefulWidget {
  static const routeName = '/webviewPage';
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
//
//    // Add a listener to on destroy WebView, so you can make came actions.
//    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
//      print("destroy");
//    });
//
//    _onStateChanged =
//        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
//      print("onStateChanged: ${state.type} ${state.url}");
//    });
//
//    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.startsWith('${buildEnvironment.baseUrl}payment/dana/auth')) {
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
                          print(data);
                          if (data.message.contains(
                              'Pembayaran sukses dan sedang di verifikasi')) {
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
