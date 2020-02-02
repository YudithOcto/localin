import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  MyChromeSafariBrowser(browserFallback) : super(bFallback: browserFallback);

  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onLoaded() {
    print("ChromeSafari browser loaded");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onLoadStart(String url) async {
    print("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(String url) async {
    print("\n\nStopped $url\n\n");
  }

  @override
  void onLoadError(String url, int code, String message) {
    print("\n\nCan't load $url.. Error: $message\n\n");
  }

  @override
  void onLoadResource(LoadedResource resource) {
    print(resource);
    super.onLoadResource(resource);
  }

  @override
  Future<JsAlertResponse> onJsAlert(String message) {
    print(message);
    return super.onJsAlert(message);
  }

  @override
  Future<JsPromptResponse> onJsPrompt(String message, String defaultValue) {
    print(message);
    return super.onJsPrompt(message, defaultValue);
  }

  @override
  Future<JsConfirmResponse> onJsConfirm(String message) {
    print(message);
    return super.onJsConfirm(message);
  }

  @override
  void onConsoleMessage(ConsoleMessage consoleMessage) {
    print(consoleMessage);
    super.onConsoleMessage(consoleMessage);
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }
}
