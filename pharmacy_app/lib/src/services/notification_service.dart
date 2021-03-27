import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
  print('on onBackgroundMessage ${message.data}');
  // Do not navigate route from here.
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'aamar_pharma', // id
    'Aamar Pharma', // title
    'This channel is used for Aamar Pharma notifications.', // description
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    showBadge: true,
    enableLights: true,
    ledColor: Colors.blue);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseCloudMessagingListeners() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("FIREBASE  initialized");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  try {
    if (Platform.isIOS) iOSPermission();

    FirebaseMessaging.instance.getToken().then((token) async {
      await Store.instance.setFirebasePushNotificationToken(token);
    });

    if (Platform.isAndroid) {
      FirebaseMessaging.instance.subscribeToTopic("pharma-admin");
      if (ServerConfig.environmentMode == "dev")
        FirebaseMessaging.instance.subscribeToTopic("pharma-admin-dev");
    }

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      // On click to start the app from beginning, this is executed.
      if (message != null) {
        print('on getInitialMessage $message.data');
        navigateToSpecificScreen();
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // On foreground app, this is executed.
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: 'launch_background',
                ),
                iOS: IOSNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                )));
      }
      Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
      print('on onMessage ${message.data['code']}');
      navigateToSpecificScreen();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      // On click the push message this is executed.
      Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
      print('on onMessageOpenedApp ${message.data}');
      navigateToSpecificScreen();
    });
  } catch (error) {
    print("ERROR in FCM Service");
    print(error);
  }
}

void navigateToSpecificScreen() async {
  AppVariableStates.instance.navigatorKey.currentState
      .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
  AppVariableStates.instance.navigatorKey.currentState
      .pushNamed('/notification');
}

void iOSPermission() {
  FirebaseMessaging.instance.requestPermission();
}

void processNotificationMessage(Map<String, dynamic> message) async {}
