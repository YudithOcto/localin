import 'dart:async';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebView extends StatefulWidget {
  static const routeName = '/articleWebview';
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

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String url = routeArgs[ArticleWebView.url];
    ArticleDetail model =
        routeArgs[ArticleWebView.articleModel] ?? ArticleDetail();
    //url = url.contains('https') ? url : url.replaceRange(0, 4, 'https');
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
            flexibleSpace: Container(
              alignment: FractionalOffset.center,
              margin: EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                      onTap: () async {
                        _isChanged = true;
                        final response =
                            await Provider.of<HomeProvider>(context)
                                .bookmarkArticle(model.id);
                        if (response.error != null) {
                          CustomToast.showCustomToast(context, response.error);
                        } else {
                          CustomToast.showCustomBookmarkToast(
                              context, response?.message, callback: () async {
                            dismissAllToast(showAnim: true);
                            await Provider.of<HomeProvider>(context)
                                .bookmarkArticle(model.id);
                            setState(() {
                              model?.isBookmark =
                                  model?.isBookmark == 0 ? 1 : 0;
                            });
                          });
                          setState(() {
                            model?.isBookmark = model?.isBookmark == 0 ? 1 : 0;
                          });
                        }
                      },
                      child: SvgPicture.asset(
                        !model.isBookmark.isBookmarked
                            ? 'images/bookmark_outline.svg'
                            : 'images/bookmark_full.svg',
                        color: model.isBookmark.isBookmarked
                            ? ThemeColors.primaryBlue
                            : null,
                      )),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                      onTap: () {
                        Share.text('Localin', '${model?.slug}', 'text/plain');
                      },
                      child: SvgPicture.asset('images/share_article.svg')),
                ],
              ),
            ),
          ),
          body: Builder(
            builder: (context) => IndexedStack(
              index: _stackToView,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: WebView(
                        initialUrl: url,
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

extension on int {
  bool get isBookmarked {
    return this == 1;
  }
}
