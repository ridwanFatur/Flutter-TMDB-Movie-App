import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:rxdart/subjects.dart';

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class LocalNotifyManager {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late InitializationSettings initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject {
    return BehaviorSubject<ReceiveNotification>();
  }

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  void requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void initializePlatform() {
    var initSettingAndroid = const AndroidInitializationSettings("logo_app");
    var initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification = ReceiveNotification(
            id: id,
            title: title!,
            body: body!,
            payload: payload!,
          );
          didReceiveLocalNotificationSubject.add(notification);
        });
    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);
  }

  void setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  void setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String? payload) async {
      onNotificationClick(payload);
    });
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<void> showSimpleNotification(
      String title, String body, String payload) async {
    var androidChannel = const AndroidNotificationDetails(
      "CHANNEL_ID",
      "CHANNEL_NAME",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannel,
      payload: payload,
    );
  }

  Future<void> showNotification(
    String title,
    String body,
    String payload,
    Movie movie,
  ) async {
    final ByteArrayAndroidBitmap posterImage = ByteArrayAndroidBitmap(
      await _getByteArrayFromUrl(movie.posterImageUrl!),
    );

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      posterImage,
      largeIcon: posterImage,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: '<b>${movie.title}</b> : ${movie.overview}',
      htmlFormatSummaryText: true,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      "CHANNEL_ID",
      "CHANNEL_NAME",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      channelDescription: 'Channel description',
      styleInformation: bigPictureStyleInformation,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
