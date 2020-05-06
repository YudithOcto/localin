import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RevampWebview extends StatefulWidget {
  static const routeName = '/revampWebview';
  static const url = 'url';
  static const isFromProfile = 'isFromProfile';
  static const title = 'title';
  @override
  _RevampWebviewState createState() => _RevampWebviewState();
}

class _RevampWebviewState extends State<RevampWebview> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  num _stackToView = 1;
  bool isFromProfile = false;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String url = routeArgs[RevampWebview.url];
    String title = routeArgs[RevampWebview.title] ?? '';
    isFromProfile = routeArgs[RevampWebview.isFromProfile] ?? false;
    //url = url.contains('https') ? url : url.replaceRange(0, 4, 'https');
    return WillPopScope(
      onWillPop: () async {
        final future = await _controller.future;
        if (future != null && await future.canGoBack()) {
          await future.goBack();
        } else {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
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
            leading: NavigationControls(_controller.future),
          ),
          body: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (webViewController) {
              _controller.complete(webViewController);
            },
          ),
        ),
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return InkWell(
            onTap: !webViewReady
                ? null
                : () async {
                    if (await controller.canGoBack()) {
                      await controller.goBack();
                    } else {
                      Navigator.of(context).pop();
                      return;
                    }
                  },
            child: Icon(
              Icons.arrow_back,
              color: ThemeColors.black80,
            ));
      },
    );
  }
}
