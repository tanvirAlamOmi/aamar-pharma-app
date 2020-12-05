import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_app/src/bloc/stream.dart';
import 'package:pharmacy_app/src/configs/server_config.dart';
import 'package:pharmacy_app/src/models/states/event.dart';
import 'package:pharmacy_app/src/store/store.dart';
import 'package:soundpool/soundpool.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
Soundpool pool = Soundpool(streamType: StreamType.notification);

void firebaseCloudMessagingListeners() async {
  int soundId = await rootBundle
      .load("assets/sounds/alert1.mp3")
      .then((ByteData soundData) {
    return pool.load(soundData);
  });

  try {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) async {
      await Store.instance.setFirebasePushNotificationToken(token);
    });

    if (Platform.isAndroid) {
      _firebaseMessaging.subscribeToTopic("fos-admin");
      if (ServerConfig.environmentMode == "dev")
        _firebaseMessaging.subscribeToTopic("fos-admin-dev");
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        try {
          // This is the foreground
          await pool.play(soundId);
          Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
          print('on onMessage $message');
        } catch (error) {}
      },
      onBackgroundMessage:
          Platform.isAndroid ? myBackgroundMessageHandler : null,
      onResume: (Map<String, dynamic> message) async {
        Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
        print('on onResume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
        print('on onLaunch $message');
      },
    );
  } catch (error) {
    print("ERROR in FCM Service");
    print(error);
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  Streamer.putEventStream(Event(EventType.REFRESH_ALL_PAGES));
}

void iOSPermission() {
  _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
    _firebaseMessaging.subscribeToTopic("fos-admin");
    if (ServerConfig.environmentMode == "dev")
      _firebaseMessaging.subscribeToTopic("fos-admin-dev");
  });
}

void processNotificationMessage(Map<String, dynamic> message) async {}
