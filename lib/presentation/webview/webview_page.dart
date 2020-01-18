import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  static const routeName = '/webviewPage';
  static const urlName = 'webUrl';
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.startsWith('https://api.localin.xyz/payment/dana/auth')) {
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
    return Scaffold(
      body: MaterialApp(
        routes: {
          '/': (_) => WebviewScaffold(
                ignoreSSLErrors: true,
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  leading: InkWell(
                    onTap: () => Navigator.of(context).pop(),
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
                      onMessageReceived: (JavascriptMessage message) {
                        print(message.message);
                      })
                ]),
                hidden: true,
                url: url,
                displayZoomControls: true,
                withZoom: true,
              ),
        },
      ),
    );
  }
}
