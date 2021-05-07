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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pharmacy_app/src/util/util.dart';
import 'package:launch_review/launch_review.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('onBackgroundMessage Execution');
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
        print('getInitialMessage Execution');
        navigateToSpecificScreen(data: message.data, pushMessageTapped: true);
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
      print('onMessage Execution');
      navigateToSpecificScreen(data: message.data, pushMessageTapped: false);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      // On click the push message this is executed.
      print('onMessageOpenedApp Execution');
      navigateToSpecificScreen(data: message.data, pushMessageTapped: true);
    });
  } catch (error) {
    print("ERROR in FCM Service");
    print(error);
  }
}

void navigateToSpecificScreen({dynamic data, bool pushMessageTapped}) async {
  print('PUSH DATA: ' + data['SERVER_DATA']);
  await Future.delayed(Duration(milliseconds: 2000));
  Streamer.putEventStream(Event(EventType.REFRESH_ORDER_PAGE));

  print('PAGE NAME: ' + AppVariableStates.instance.pageName);

  if (pushMessageTapped) {
    print('PUSH MESSAGE TAPPED');
    AppVariableStates.instance.navigatorKey.currentState
        .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
    AppVariableStates.instance.navigatorKey.currentState
        .pushNamed('/notification');
    return;
  }

  switch (AppVariableStates.instance.pageName) {
    case AppEnum.PAGE_ADD_ITEMS:
      break;

    case AppEnum.PAGE_ADD_NEW_ADDRESS:
      break;

    case AppEnum.PAGE_CONFIRM_INVOICE:
      break;

    case AppEnum.PAGE_CONFIRM_ORDER:
      break;

    case AppEnum.PAGE_INITIAL_TUTORIAL_SCROLLING:
      break;

    case AppEnum.PAGE_ORDER_FINAL_INVOICE:
      break;

    case AppEnum.PAGE_REPEAT_ORDER_CHOICE:
      break;

    case AppEnum.PAGE_SPECIAL_REQUEST_PRODUCT:
      break;

    case AppEnum.PAGE_UPLOAD_PRESCRIPTION_VERIFY:
      break;

    case AppEnum.PAGE_VERIFICATION:
      break;

    default:
      switch (data['SERVER_DATA']) {
        case 'ANYTHING':
          break;

        case 'UPDATE_APP':
          LaunchReview.launch(
              androidAppId: 'com.arbree.aamarpharma', iOSAppId: '123');
          break;

        default:
          AppVariableStates.instance.navigatorKey.currentState
              .pushNamedAndRemoveUntil(
                  '/main', (Route<dynamic> route) => false);
          AppVariableStates.instance.navigatorKey.currentState
              .pushNamed('/notification');
          break;
      }
  }
}

void iOSPermission() {
  FirebaseMessaging.instance.requestPermission();
}
