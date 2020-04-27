import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:localin/build_environment.dart';

class WebViewPage extends StatefulWidget {
  static const routeName = '/webviewPage';
  static const urlName = 'webUrl';
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
    url = url.contains('https') ? url : url.replaceRange(0, 4, 'https');
    return Scaffold(
      body: MaterialApp(
        routes: {
          '/': (_) => WebviewScaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  leading: InkWell(
                    onTap: () async {
                      if (await flutterWebviewPlugin.canGoBack()) {
                        flutterWebviewPlugin.goBack();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                    ),
                  ),
                ),
                withJavascript: true,
                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage data) {
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
                url: url,
                displayZoomControls: true,
                withOverviewMode: true,
                useWideViewPort: true,
                clearCache: true,
                clearCookies: true,
                withZoom: true,
              ),
        },
      ),
    );
  }
}
