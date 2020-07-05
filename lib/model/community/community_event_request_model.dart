import 'dart:typed_data';

class CommunityEventRequestModel {
  String eventSlug;
  String eventName;
  String eventDesc;
  String eventAudience;
  DateTime startDate;
  DateTime endDate;
  String startTime;
  String endTime;
  String location;
  List<Uint8List> selectedImage;
  bool isOnlineEvent;

  CommunityEventRequestModel({
    this.eventSlug,
    this.eventName,
    this.eventDesc,
    this.eventAudience,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.location,
    this.selectedImage,
    this.isOnlineEvent,
  });
}
