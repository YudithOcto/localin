
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_event_request_model.dart';
import 'package:localin/model/community/community_event_response_model.dart';
import 'package:localin/utils/location_helper.dart';

class CommunityCreateEventProvider with ChangeNotifier {
  final _repository = Repository();
  final eventFormNameController = TextEditingController();
  final eventFormDescriptionController = TextEditingController();
  final eventFormAudienceController = TextEditingController();
  final eventStartDateController = TextEditingController();
  final eventEndDateController = TextEditingController();
  GooglePlace googlePlace;
  String _communityId = '';

  String get communityId => _communityId;
  String _eventId;

  CommunityCreateEventProvider(String communityId,
      {CommunityEventRequestModel model}) {
    googlePlace = GooglePlace(kGoogleApiKey);
    eventFormNameController.addListener(() {
      notifyListeners();
    });
    eventFormDescriptionController.addListener(() {
      notifyListeners();
    });
    eventFormAudienceController.addListener(() {
      notifyListeners();
    });
    eventStartDateController.addListener(() {
      notifyListeners();
    });
    eventEndDateController.addListener(() {
      notifyListeners();
    });
    _communityId = communityId;

    if (model != null) {
      setPreviousModel(model);
    }
  }

  setPreviousModel(CommunityEventRequestModel model) {
    _eventId = model.eventSlug;
    eventFormNameController.text = model.eventName;
    eventFormAudienceController.text = model.eventAudience;
    eventFormDescriptionController.text = model.eventDesc;
    _selectedStartTime = TimeOfDay(
        hour: int.parse(model.startTime.substring(0, 2)),
        minute: int.parse(model.startTime.substring(3, 5)));
    _selectedEndTime = TimeOfDay(
        hour: int.parse(model.endTime.substring(0, 2)),
        minute: int.parse(model.endTime.substring(3, 5)));
    _selectedStartDate = model.startDate;
    _selectedEndDate = model.endDate;
    eventStartDateController.text = startTime;
    eventEndDateController.text = endTime;
    _selectedImage = model.selectedImage;
    _selectedLocation = model.location;
    _isOnlineEvent = model.isOnlineEvent;
  }

  String _selectedLocation = '';

  String get selectedLocation => _selectedLocation;
  double _latitude = 0.0;
  double _longitude = 0.0;

  void setLocation(AutocompletePrediction value) async {
    _selectedLocation = value.description;
    if (value != null && value.placeId != null && value.placeId.isNotEmpty) {
      await getMapDetails(value.placeId);
    }
    notifyListeners();
  }

  Future<void> getMapDetails(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null) {
      _latitude = result?.result?.geometry?.location?.lat;
      _longitude = result?.result?.geometry?.location?.lng;
    }
  }

  bool _isOnlineEvent = false;

  bool get isOnlineEvent => _isOnlineEvent;

  set enabledOnlineEvent(bool value) {
    _isOnlineEvent = value;
    notifyListeners();
  }

  List<Uint8List> _selectedImage = [];

  List<Uint8List> get selectedImage => _selectedImage;

  addSelectedImage(List<Uint8List> images) {
    _selectedImage.clear();
    _selectedImage.addAll(images);
    notifyListeners();
  }

  removeSelectedImage(int index) {
    _selectedImage.removeAt(index);
    notifyListeners();
  }

  DateTime _selectedStartDate;

  DateTime get selectedStartDate => _selectedStartDate;
  TimeOfDay _selectedStartTime;

  DateTime _selectedEndDate;

  DateTime get initialEndDate => _selectedStartDate;
  TimeOfDay _selectedEndTime;

  final format = DateFormat('EEEE, MMM dd, yyyy');

  String get startTime {
    return '${format.format(_selectedStartDate)} '
        'at ${_selectedStartTime.hour}:${_selectedStartTime.minute}  ${_selectedStartTime.customPeriod}';
  }

  String get endTime {
    String formatter = '${format.format(_selectedEndDate)} '
        'at ${_selectedEndTime.hour}:${_selectedEndTime.minute}  ${_selectedStartTime.customPeriod}';
    return formatter;
  }

  void startEventDateTime(DateTime value) {
    _selectedStartDate = value;
    _selectedStartTime = TimeOfDay(hour: value.hour, minute: value.minute);
    eventStartDateController.text = startTime;
    notifyListeners();
  }

  void endEventDateTime(DateTime value) {
    _selectedEndDate = value;
    _selectedEndTime = TimeOfDay(hour: value.hour, minute: value.minute);
    eventEndDateController.text = endTime;
    notifyListeners();
  }

  String get isShareButtonActive {
    if (eventStartDateController.text.isEmpty) {
      return 'Start date time is required';
    } else if (eventEndDateController.text.isEmpty) {
      return 'End date time is required';
    } else if (eventFormNameController.text.isEmpty) {
      return 'Name of event is required';
    } else if (eventFormDescriptionController.text.isEmpty) {
      return 'Description of event is required';
    } else if (eventFormAudienceController.text.isEmpty) {
      return 'Audience of event is required';
    } else if (!_isOnlineEvent && _selectedLocation.isEmpty) {
      return 'Location of event is required';
    } else if (_selectedImage.isEmpty) {
      return 'Image of event is required';
    } else {
      return '';
    }
  }

  final formatter = DateFormat('yyyy-MM-dd');

  FormData get eventFormModel {
    Map<String, dynamic> map = Map();
    if (_eventId != null) {
      map['id'] = _eventId;
    }
    map['judul'] = eventFormNameController.text ?? null;
    map['deskripsi'] = eventFormDescriptionController.text ?? null;
    map['start_date'] = formatter.format(_selectedStartDate);
    map['end_date'] = formatter.format(_selectedEndDate);
    map['start_time'] = '${_selectedStartTime.hour}:${_selectedEndTime.minute}';
    map['end_time'] = '${_selectedEndTime.hour}:${_selectedEndTime.minute}';
    map['alamat'] = _selectedLocation;
    map['peserta'] = eventFormAudienceController.text;
    map['lampiran_tipe'] = 'gambar';
    map['is_online'] = _isOnlineEvent;
    if (!_isOnlineEvent) {
      map['latitude'] = _latitude;
      map['longitude'] = _longitude;
    }
    if (_selectedImage != null) {
      map['lampiran'] = _selectedImage
          .map((e) => MultipartFile.fromBytes(e, filename: 'eventGambar'))
          .toList();
    }
    return FormData.fromMap(map);
  }

  Future<CommunityEventResponseModel> createEvent() async {
    final response =
        await _repository.createCommunityEvent(_communityId, eventFormModel);
    return response;
  }

  @override
  void dispose() {
    eventFormNameController.dispose();
    eventFormDescriptionController.dispose();
    super.dispose();
  }
}

extension on TimeOfDay {
  String get customPeriod {
    if (this.period == DayPeriod.am) {
      return 'AM';
    } else {
      return 'PM';
    }
  }
}
