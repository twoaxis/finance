import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:twoaxis_finance/core/abstract/notification_service.dart';

class NotificationServiceImpl implements NotificationService {
  final FirebaseMessaging _firebaseMessaging;

  NotificationServiceImpl({FirebaseMessaging? messaging})
      : _firebaseMessaging = messaging ?? FirebaseMessaging.instance;

  @override
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  @override
  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
