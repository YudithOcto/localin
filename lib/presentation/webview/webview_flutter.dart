import 'dart:async';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewFlutter extends StatefulWidget {
  static const String routeName = '/webvieeflter';
  static const String url = '/url';
  @override
  _WebviewFlutterState createState() => _WebviewFlutterState();
}

class _WebviewFlutterState extends State<WebviewFlutter> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          print(message);
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        final routeArgs =
            ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        String url = routeArgs[WebviewFlutter.url];
        return WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) async {
            print('allowing navigation to $request');
            final result = await _controller.future;
            result.evaluateJavascript(result.toString());
            print(result);
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }
}
