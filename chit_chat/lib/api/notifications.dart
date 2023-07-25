import 'package:chit_chat/routes/route_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationManager {
  NotificationManager();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final sharedPreferences = Get.find<SharedPreferences>();
  String? _deviceToken;

  void setupFirebaseMessaging() {
    // Request permission to receive notifications (for iOS only)
    _firebaseMessaging.requestPermission();

    // Handle incoming messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the incoming message here
      _showNotification(message);
    });

    // Handle notification when the app is in the background
    //FirebaseMessaging.onBackgroundMessage(_handleNotification);

    // Handle notification when the app is terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the notification when the app is opened from a terminated state
    });
  }

  Future<void> initNotifications() async {
    if (sharedPreferences.containsKey("deviceToken")) {
      _deviceToken = sharedPreferences.getString("deviceToken");
    } else {
      getDeviceToken();
    }
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS, // Add the iOS configuration here.
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    final String title = message.notification?.title ?? "Notification";
    final String body = message.notification?.body ?? "New notification";

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> _handleNotification(RemoteMessage message) async {
    // Handle the notification when the app is opened from a terminated state
    // Navigate the user to the relevant screen or page based on the notification data

    final data =
        message.data; // Get the custom data payload from the notification

    // Use Flutter's Navigator to navigate to the relevant screen
    Get.toNamed(RouteHelper.getSignInPage());
  }

  String? get deviceToken => _deviceToken;

  Future<void> getDeviceToken() async {
    _deviceToken = await _firebaseMessaging.getToken();
    if (_deviceToken != null) {
      await sharedPreferences.setString("deviceToken", _deviceToken!);
    }
  }
}
