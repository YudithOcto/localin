import 'dart:convert';

class AmpResponseModel {
  AmpResponseModel({
    this.ampUrls,
    this.message,
  });

  List<AmpUrl> ampUrls;
  String message;

  factory AmpResponseModel.fromJson(Map<String, dynamic> json) {
    String amp = json['ampUrls'] == null ? 'urlErrors' : 'ampUrls';
    return AmpResponseModel(
      ampUrls: List<AmpUrl>.from(json["$amp"].map((x) => AmpUrl.fromJson(x))),
      message: '',
    );
  }

  Map<String, dynamic> toJson() => {
        "ampUrls": List<dynamic>.from(ampUrls.map((x) => x.toJson())),
      };

  AmpResponseModel.withError(String value) : message = value;
}

class AmpUrl {
  AmpUrl({
    this.errorCode,
    this.errorMessage,
    this.originalUrl,
    this.ampUrl,
    this.cdnAmpUrl,
  });

  String errorCode;
  String errorMessage;
  String originalUrl;
  String ampUrl;
  String cdnAmpUrl;

  factory AmpUrl.fromJson(Map<String, dynamic> json) => AmpUrl(
        errorCode: json["errorCode"] ?? '',
        errorMessage: json["errorMessage"] ?? '',
        originalUrl: json["originalUrl"] ?? '',
        ampUrl: json["ampUrl"] ?? '',
        cdnAmpUrl: json["cdnAmpUrl"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "errorCode": errorCode,
        "errorMessage": errorMessage,
        "originalUrl": originalUrl,
        "ampUrl": ampUrl,
        "cdnAmpUrl": cdnAmpUrl,
      };
}
