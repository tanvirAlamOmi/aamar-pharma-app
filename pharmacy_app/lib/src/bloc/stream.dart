import 'dart:async';
import 'package:pharmacy_app/src/models/states/event.dart';

class Streamer {
  static StreamController<Event> _streamControllerEvent =
      new StreamController.broadcast();
  static StreamController<int> _streamControllerTotalOrder =
      new StreamController.broadcast();

  static Stream<Event> getEventStream() {
    return _streamControllerEvent.stream;
  }

  static Stream<Event> getTotalOrderStream() {
    return _streamControllerEvent.stream;
  }

  static void putEventStream(Event event) {
    print("Event Changed:");
    print(event.eventType.toString());
    _streamControllerEvent.sink.add(event);
  }

  static void putTotalOrderStream(int totalOrder) {
    _streamControllerTotalOrder.sink.add(totalOrder);
  }
}
