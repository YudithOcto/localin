import 'package:localin/api/repository.dart';
import 'package:localin/model/notification/notification_model.dart';
import 'package:localin/provider/base_model_provider.dart';

class NotificationProvider extends BaseModelProvider {
  Repository _repository = Repository();

  Future<List<NotificationDetailModel>> getNotificationList(
      int offset, int limit) async {
    final response = await _repository.getNotificationList(offset, limit);
    return null;
  }

  Future<bool> updateReadNotification(String notifId) async {
    final response = await _repository.readNotificationUpdate(notifId);
    return response;
  }
}
