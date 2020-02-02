import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewNewestPage extends StatefulWidget {
  static const routeName = '/webviewNewestPage';
  static const webViewUrl = '/urlWebView';
  @override
  _WebViewNewestPageState createState() => _WebViewNewestPageState();
}

class _WebViewNewestPageState extends State<WebViewNewestPage> {
  InAppWebViewController webView;
  double progress = 0;
  String url = '';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    url = routeArgs[WebViewNewestPage.webViewUrl];
    return Scaffold(
      appBar: AppBar(
        title: Text('Web'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: InAppWebView(
                  initialUrl: url,
                  initialOptions: InAppWebViewWidgetOptions(
                      inAppWebViewOptions: InAppWebViewOptions(
                        debuggingEnabled: true,
                      ),
                      androidInAppWebViewOptions: AndroidInAppWebViewOptions(
                        loadsImagesAutomatically: true,
                        loadWithOverviewMode: true,
                        domStorageEnabled: true,
                        thirdPartyCookiesEnabled: true,
                        hardwareAcceleration: true,
                      )),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                    print(url);
                    webView.getHtml().then((value) {
                      print(value);
                    });
                  },
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    new Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                  onConsoleMessage: (controller, message) {
                    webView = controller;
                    print(url);
                    webView.getHtml().then((value) {
                      print(value);
                    });

                    if (message.message == 'success') {
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.of(context).pop('success');
                      });
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }
}
