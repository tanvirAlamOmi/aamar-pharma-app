import 'dart:async';
import 'package:pharmacy_app/src/models/general/Client_Enum.dart';
import 'package:pharmacy_app/src/repo/notification_repo.dart';
import 'package:tuple/tuple.dart';

import 'stream.dart';

class AutoRefreshTimer {
  Timer currentTimer;
  int notificationTimer = 0;

  void autoRefresh() {
    currentTimer =
        new Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      if (notificationTimer % 5 == 0) {
        Tuple2<int, String> notificationCountResponse =
            await NotificationRepo.instance.notificationCount();

        if (notificationCountResponse.item2 == ClientEnum.RESPONSE_SUCCESS) {
          Streamer.putTotalNotificationCountStream(
              notificationCountResponse.item1);
        } else {
          Streamer.putTotalNotificationCountStream(0);
        }
      }

      notificationTimer += 1;
    });
  }

  void stopTimer() {
    currentTimer?.cancel();
    AutoRefreshTimer.setNullInstance();
  }

  static setNullInstance() {
    AutoRefreshTimer.autoRefreshTimerClass = null;
  }

  static AutoRefreshTimer autoRefreshTimerClass;
  static AutoRefreshTimer get instance =>
      AutoRefreshTimer.autoRefreshTimerClass ??= AutoRefreshTimer();
}
