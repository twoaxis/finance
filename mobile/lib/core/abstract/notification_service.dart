abstract class NotificationService {
  Future<void> initialize();
  Future<String?> getToken();
}