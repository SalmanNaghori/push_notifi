import 'package:flutter/material.dart';
import 'package:push_notifi/notification_services.dart';
import 'package:push_notifi/screens/navigate_screen.dart';

import '../const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationsService notificationsService = NotificationsService();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    notificationsService.requestNotificationsPermission();
    notificationsService.getDeviceToken().then((value) {
      print("DeviceToken::::$value");
    });
    // notificationsService.firebaseInit(context);
    // notificationsService.background();
    // notificationsService.killApp();
    // notificationsService.forgroundNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Notification"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              navigateToPage(NavigateScreen(title: "title"));
            },
            child: Text("click")),
      ),
    );
  }
}
