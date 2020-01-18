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
      body: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: InAppWebView(
          initialUrl: "$url",
          //initialFile: "assets/index.html",
          initialHeaders: {},
          initialOptions: InAppWebViewWidgetOptions(
              androidInAppWebViewOptions:
                  AndroidInAppWebViewOptions(safeBrowsingEnabled: true)),
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            print("onLoadStart $url");
            setState(() {
              this.url = url;
            });
          },
          onLoadStop: (InAppWebViewController controller, String url) async {
            print("onLoadStop $url");
            setState(() {
              this.url = url;
            });
            /*var origins = await WebStorageManager.instance().android.getOrigins();
                    for (var origin in origins) {
                      print(origin);
                      print(await WebStorageManager.instance().android.getQuotaForOrigin(origin: origin.origin));
                      print(await WebStorageManager.instance().android.getUsageForOrigin(origin: origin.origin));
                    }
                    await WebStorageManager.instance().android.deleteAllData();
                    print("\n\nDELETED\n\n");
                    origins = await WebStorageManager.instance().android.getOrigins();
                    for (var origin in origins) {
                      print(origin);
                      await WebStorageManager.instance().android.deleteOrigin(origin: origin.origin);
                    }*/
            /*var records = await WebStorageManager.instance().ios.fetchDataRecords(dataTypes: IOSWKWebsiteDataType.ALL);
                    for(var record in records) {
                      print(record);
                    }
                    await WebStorageManager.instance().ios.removeDataModifiedSince(dataTypes: IOSWKWebsiteDataType.ALL, date: DateTime(0));
                    print("\n\nDELETED\n\n");
                    records = await WebStorageManager.instance().ios.fetchDataRecords(dataTypes: IOSWKWebsiteDataType.ALL);
                    for(var record in records) {
                      print(record);
                    }*/
          },
          onProgressChanged: (InAppWebViewController controller, int progress) {
            setState(() {
              this.progress = progress / 100;
            });
          },
        ),
      ),
    );
  }
}
