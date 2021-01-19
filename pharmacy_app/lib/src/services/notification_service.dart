import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:soundpool/soundpool.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Soundpool pool = Soundpool(streamType: StreamType.notification);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'amar_pharma', // id
    'Amar Pharma', // title
    'This channel is used for Aamar Pharma notifications.', // description
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    showBadge: true,
    enableLights: true,
    ledColor: Colors.blue);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void firebaseCloudMessagingListeners() async {
  int soundId = await rootBundle
      .load("assets/sounds/alert1.mp3")
      .then((ByteData soundData) {
    return pool.load(soundData);
  });

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

    FirebaseMessaging.onMessage.listen((message) async {
      await pool.play(soundId);
      Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
      print('on onMessage $message');
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      await pool.play(soundId);
      Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
      print('on onMessage $message');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await pool.play(soundId);
      Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
      print('on onMessage $message');
    });
  } catch (error) {
    print("ERROR in FCM Service");
    print(error);
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
}

void iOSPermission() {
  FirebaseMessaging.instance.requestPermission();
}

void processNotificationMessage(Map<String, dynamic> message) async {}
