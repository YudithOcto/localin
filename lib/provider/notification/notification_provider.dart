import 'dart:async';
import 'dart:math';
import 'package:localin/api/repository.dart';
import 'package:localin/model/notification/notification_model.dart';
import 'package:localin/provider/base_model_provider.dart';

class NotificationProvider extends BaseModelProvider {
  Repository _repository = Repository();
  bool _isCanLoadMore = true;
  int _totalPageRequest = 10, _offsetPageRequest = 1;
  int totalInbox = 0;
  List<NotificationDetailModel> _notificationListData = [];
  StreamController<NotificationState> _notificationState =
      StreamController<NotificationState>.broadcast();

  Future<void> getNotificationList({bool isRefresh = false}) async {
    _notificationState.add(NotificationState.Loading);
    if (isRefresh) {
      _offsetPageRequest = 1;
      _notificationListData.clear();
      _isCanLoadMore = true;
    }

    if (!_isCanLoadMore) {
      _notificationState.add(NotificationState.Success);
      return null;
    }

    final response = await _repository.getNotificationList(
        _offsetPageRequest, _totalPageRequest);
    if (response != null && response.model.data != null) {
      if (response.model.data.isEmpty) {
        _notificationState.add(NotificationState.NoData);
      } else {
        _notificationState.add(NotificationState.Success);
      }
      _notificationListData.addAll(response.model.data);
      totalInbox = response.model.total;
      _isCanLoadMore = totalInbox > _notificationListData.length;
      _offsetPageRequest += 1;
    } else {
      _isCanLoadMore = false;
      _notificationState.add(NotificationState.NoData);
    }
    notifyListeners();
  }

  Future<bool> updateReadNotification(String notifId) async {
    final response = await _repository.readNotificationUpdate(notifId);
    return response;
  }

  void deleteItem(int index) {
    _notificationListData.removeAt(index);
    notifyListeners();
  }

  void undoDeleteItem(int index, NotificationDetailModel item) {
    _notificationListData.insert(index, item);
    notifyListeners();
  }

  Future<String> deleteNotificationById(String notifId) async {
    return await _repository.deleteNotificationById(notifId);
  }

  Future<String> unDeleteNotificationId(String notifId) async {
    return await _repository.undoNotificationDelete(notifId);
  }

  Future<String> deleteAllNotification() async {
    return await _repository.deleteAllNotification();
  }

  List<NotificationDetailModel> get notificationList => _notificationListData;
  Stream<NotificationState> get notificationStateStream =>
      _notificationState.stream;
  bool get isCanLoadMore => _isCanLoadMore;

  @override
  void dispose() {
    _notificationState.close();
    super.dispose();
  }
}

extension on List {
  bool get isNotNullNorEmpty {
    return this != null && this.isNotEmpty;
  }
}

enum NotificationState { Loading, NoData, Success }
