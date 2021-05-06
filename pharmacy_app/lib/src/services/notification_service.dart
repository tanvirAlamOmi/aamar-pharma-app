import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/general/App_Enum.dart';
import 'package:pharmacy_app/src/models/states/app_vary_states.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pharmacy_app/src/util/util.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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

    FirebaseMessaging.instance.subscribeToTopic("pharma-push-service");
    if (Platform.isAndroid)
      FirebaseMessaging.instance
          .subscribeToTopic("pharma-push-service-android");
    if (Platform.isIOS)
      FirebaseMessaging.instance.subscribeToTopic("pharma-push-service-ios");

    if (ServerConfig.environmentMode == "dev")
      FirebaseMessaging.instance.subscribeToTopic("pharma-push-service-dev");

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      // On click to start the app from beginning, this is executed.
      if (message != null) {
        print('on getInitialMessage $message.data');
        navigateToSpecificScreen(message.data);
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
                    channel.id, channel.name, channel.description,
                    icon: 'ic_pharma_push',
                    color: Util.colorFromHex('#473fa8')),
                iOS: IOSNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                )));
      }
      print('on onMessage ${message.data['code']}');
      navigateToSpecificScreen(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      // On click the push message this is executed.
      print('on onMessageOpenedApp ${message.data}');
      navigateToSpecificScreen(message.data);
    });
  } catch (error) {
    print("ERROR in FCM Service");
    print(error);
  }
}

void navigateToSpecificScreen(dynamic code) async {
  print('PUSH DATA: ' + code['SERVER_DATA']);
  await Future.delayed(Duration(milliseconds: 1500));
  Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));

  switch (AppVariableStates.instance.pageName) {
    case AppEnum.PAGE_ADD_ITEMS:
      break;

    case AppEnum.PAGE_ADD_NEW_ADDRESS:
      break;

    case AppEnum.CONFIRM_INVOICE_PAGE:
      break;

    case AppEnum.PAGE_CONFIRM_ORDER:
      break;

    case AppEnum.PAGE_INITIAL_TUTORIAL_SCROLLING:
      break;
  }

  switch (code['SERVER_DATA']) {
    case 'VALET_CANCEL':
      AppVariableStates.instance.navigatorKey.currentState
          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
      break;
    default:
      AppVariableStates.instance.navigatorKey.currentState
          .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
      AppVariableStates.instance.navigatorKey.currentState
          .pushNamed('/notification');
      break;
  }
}

void prevNavigateToSpecificScreen() async {
  AppVariableStates.instance.navigatorKey.currentState
      .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
  AppVariableStates.instance.navigatorKey.currentState
      .pushNamed('/notification');
}

void iOSPermission() {
  FirebaseMessaging.instance.requestPermission();
}

void processNotificationMessage(Map<String, dynamic> message) async {}
