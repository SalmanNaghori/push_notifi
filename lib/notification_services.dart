import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notifi/main.dart';
import 'package:push_notifi/screens/navigate_screen.dart';

import 'const.dart';
import 'globle_context.dart';

class NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  init() {
    //Todo:forground
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          createanddisplaynotification(message);
        }
      },
    );

    //Todo:background notification
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("====>>>>FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          initialize();
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );

    //Todo:App kill
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        Future.delayed(
          const Duration(seconds: 2),
          () async {
            await Firebase.initializeApp();
            if (message != null) {
              if (message.data['_id'] != null) {
                navigateToOtherScreen(message.data['_id']);
              }
            }
          },
        );
      },
    );
  }
  // void initLocalNotifications(
  //     BuildContext contect, RemoteMessage message) async {
  //   var androidInitializationSettings =
  //       AndroidInitializationSettings('mipmap/ic_launcher');
  //   var iosInitializationSettings = DarwinInitializationSettings();

  //   var initializationSetting = InitializationSettings(
  //     android: androidInitializationSettings,
  //     iOS: iosInitializationSettings,
  //   );
  //   await _flutterLocalNotificationsPlugin.initialize(initializationSetting,

  //     );
  // }
  void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("======>>>>message11111> ${response.payload.toString()}");
        print("onSelectNotification");
        if (response.payload!.isNotEmpty) {
          String id = response.payload.toString();
          print("======>>>>Router Value1234 $id");

          // Navigate to your screen using the retrieved id
          print("push");

          if (id.isNotEmpty) {
            print("push");

            // Navigator.push(
            //   GlobalVariable.appContext,
            //   MaterialPageRoute(
            //     builder: (context) => NavigateScreen(
            //       title: id,
            //     ),
            //   ),
            // );
            navigateToOtherScreen(id);
          }
        }
      },
    );
  }

  Future<void> navigateToOtherScreen(String id) async {
    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        await navigateToPage(
          NavigateScreen(title: id),
        );
      },
    );
  }

  // after initialize we create channel in createanddisplaynotification method

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      print("===========${e}");
    }
  }

  // Future<void> showNotification(RemoteMessage message) async {
  //   AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     message.notification!.android!.channelId.toString(),
  //     message.notification!.android!.channelId.toString(),
  //     importance: Importance.max,
  //   );
  //   AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     channel.id.toString(),
  //     channel.name.toString(),
  //     channelDescription: "Notes App Channel",
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     playSound: true,
  //     icon: '@mipmap/ic_launcher',
  //     ticker: 'ticker',
  //     styleInformation: DefaultStyleInformation(true, true),
  //   );

  //   DarwinNotificationDetails darwinNotificationDetails =
  //       DarwinNotificationDetails(
  //     presentSound: true,
  //     presentBadge: true,
  //     presentAlert: true,
  //   );

  //   NotificationDetails notificationDetails = NotificationDetails(
  //       android: androidNotificationDetails, iOS: darwinNotificationDetails);
  //   Future.delayed(Duration.zero, () {
  //     _flutterLocalNotificationsPlugin.show(
  //         0,
  //         message.notification!.title.toString(),
  //         message.notification!.body.toString(),
  //         notificationDetails);
  //   });
  // }

  // void firebaseInit(BuildContext context) {
  //   FirebaseMessaging.onMessage.listen((message) {
  //     print("===============>${message.notification!.title.toString()}");
  //     print("${message.notification!.body.toString()}");
  //     if (Platform.isAndroid) {
  //       initLocalNotifications(context, message);
  //       showNotification(message);
  //     }
  //   });
  // }

  void requestNotificationsPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("=====>>>>>>>User Granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("====>>>>>User Granted provisional permission");
    } else {
      print(">>>>>>=======>>>>User denied permission");
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  // isTokenRefresh() {
  //   messaging.onTokenRefresh.listen((event) {
  //     event.toString();
  //     print("event");
  //   });
  // }

  // 1. This method call when app in terminated state and you get a notification
  // when you click on notification app open from terminated state and you can get notification data in this method
  // void killApp() {
  //   FirebaseMessaging.instance.getInitialMessage().then(
  //     (message) {
  //       print("FirebaseMessaging.instance.getInitialMessage");
  //       if (message != null) {
  //         print("New Notification");
  //         if (message.data['_id'] != null) {
  //           Navigator.push(
  //             GlobalVariable.appContext,
  //             MaterialPageRoute(
  //               builder: (context) => NavigateScreen(
  //                 title: message.data['_id'],
  //               ),
  //             ),
  //           );
  //         }
  //       }
  //     },
  //   );
  // }

  // 2. This method only call when App in forground it mean app must be opened
  // void forgroundNotification() {
  //   FirebaseMessaging.onMessage.listen(
  //     (message) {
  //       print("FirebaseMessaging.onMessage.listen");
  //       if (message.notification != null) {
  //         print(message.notification!.title);
  //         print(message.notification!.body);
  //         print("message.data11 ${message.data}");
  //         createanddisplaynotification(message);
  //       }
  //     },
  //   );
  // }

  // 3. This method only call when App in background and not terminated(not closed)
  // void background() {
  //   FirebaseMessaging.onMessageOpenedApp.listen(
  //     (message) {
  //       MyApp.logger.e("====>>>>FirebaseMessaging.onMessageOpenedApp.listen");
  //       if (message.notification != null) {
  //         print(message.notification!.title);
  //         print(message.notification!.body);
  //         print("message.data22 ${message.data['_id']}");
  //       }
  //     },
  //   );
  // }
}
