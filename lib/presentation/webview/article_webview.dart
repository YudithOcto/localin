import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/widgets/news_detail/appbar_bookmark_share_action_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebView extends StatefulWidget {
  static const routeName = 'ArticleWebviewPage';
  static const url = 'url';
  static const title = 'title';
  static const articleModel = 'articleModel';
  @override
  _ArticleWebViewState createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  num _stackToView = 1;
  bool _isChanged = false;
  Future checkAmp;
  bool _isInit = true;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
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
        final routeArgs =
            ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        String url = routeArgs[ArticleWebView.url];
        return url;
      }
    } else {
      return '';
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      String url = routeArgs[ArticleWebView.url];
      checkAmp = checkAmpUrl(url);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    ArticleDetail model =
        routeArgs[ArticleWebView.articleModel] ?? ArticleDetail();

    return WillPopScope(
      onWillPop: () async {
        final future = await _controller.future;
        if (future != null && await future.canGoBack()) {
          await future.goBack();
        } else {
          if (_isChanged) {
            Navigator.of(context).pop(model.isBookmark);
          } else {
            Navigator.of(context).pop();
          }
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeColors.black0,
            elevation: 0,
            leading: NavigationControls(_controller.future),
            titleSpacing: 0.0,
            title: Container(
              margin: EdgeInsets.only(right: 80.0),
              child: Text(
                model.title ?? 'Local News',
                overflow: TextOverflow.ellipsis,
                style: ThemeText.sfMediumHeadline,
              ),
            ),
            flexibleSpace: AppBarBookMarkShareActionWidget(
              articleDetail: model,
            ),
          ),
          body: FutureBuilder<String>(
              future: checkAmp,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Builder(
                  builder: (context) => IndexedStack(
                    index: _stackToView,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: WebView(
                              initialUrl: snapshot.data,
                              javascriptMode: JavascriptMode.unrestricted,
                              onWebViewCreated: (webViewController) {
                                _controller.complete(webViewController);
                              },
                              onPageFinished: _handleLoad,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  ),
                );
              }),
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

extension on int {
  bool get isBookmarked {
    return this == 1;
  }
}
