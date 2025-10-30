//import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notificationservice{
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static Future<void> initialize() async{
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iossettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iossettings,
    );

    await _plugin.initialize(settings);
  }

  static Future<void> shownotification() async{
    const androiddetails=AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high
      );

      const iosdetails = DarwinNotificationDetails();

      const notificationdetails=NotificationDetails(
        android: androiddetails,
        iOS: iosdetails,
      );

      await _plugin.show(
        0,
       'Password manager', 
       'Password added successfully',
       notificationdetails
       
        );
    
  }

}