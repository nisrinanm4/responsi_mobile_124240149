import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initSettings);

    // Meminta izin notifikasi untuk Android 13 ke atas
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Menampilkan Immediate Notification saat spell favorit dihapus
  static Future<void> showDeleteNotification({
    required String spellName,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'delete_channel',
      'Delete Notification',
      channelDescription: 'Notification when favorite spell is deleted',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecond,
      'Delete notification',
      'You deleted $spellName from your fav list!',
      notificationDetails,
    );
  }
}