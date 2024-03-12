import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/buisness_logic_layer/task_bloc/task_cubit.dart';
import 'package:todo_app/ui_layer/screens/notification_screen.dart';
import '../data_layer/models/task_model.dart';
import '../main.dart';

class MyNotifications {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void requestPermission() async {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();

    notificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: false,
    );
  }

  void initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('logo');
    final DarwinInitializationSettings iosInitializingSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializingSettings,
      macOS: iosInitializingSettings,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  void onNotificationSelected(context) {}

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    print('notification clicked');
    List<Task>? tasks =
        BlocProvider.of<TasksCubit>(homeScreenKey.currentContext!).tasks;
    Task task = tasks.firstWhere((task) => task.taskId == details.id);
    Navigator.of(homeScreenKey.currentContext!).push(MaterialPageRoute(
        builder: (ctx) => NotificationScreen(
            date: task.date.toString(),
            description: task.description.toString(),
            title: task.title.toString())));
  }

  Future<NotificationDetails> notificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channel_Id',
      'channel_Name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
    );
    const DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    return Future(() => notificationDetails);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime taskDate,
    required String repeat,
  }) async {
    print("normal notification date ===== $taskDate");
    print('repeated notification date=== ${setNotificationByRepeat(taskDate, repeat)}');
    notificationsPlugin.zonedSchedule(
      id,
      title,
      body,

      tz.TZDateTime.from(
        setNotificationByRepeat(taskDate, repeat),
        tz.local,
      ),
      await notificationDetails(),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }


//////////////////////////////////
  DateTime setNotificationByRepeat(DateTime taskDate, String repeat) {
    DateTime x = taskDate;
    switch (repeat) {
      case 'daily':
        while(x.isBefore(DateTime.now())){x=x.add(const Duration(days: 1));}
        return x;
      case 'weekly':
        while(x.isBefore(DateTime.now())){x=x.add(const Duration(days: 7));}
        return x;
      case 'monthly':
        int add = 0;
        while(x.isBefore(DateTime.now())){
          add=add+1;
          x=DateTime(
            taskDate.year,
            taskDate.month +add,
            taskDate.day,
            taskDate.hour,
            taskDate.minute,
          );}

        return x;
      default:
        return DateTime.now().add(const Duration(seconds: 1));
    }
  }

  void cancelNotification(int id) {
    notificationsPlugin.cancel(id);
  }
}
