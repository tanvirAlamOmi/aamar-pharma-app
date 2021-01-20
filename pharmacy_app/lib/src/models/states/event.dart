class Event {
  EventType _eventType;
  int _id;

  Event(EventType eventType) {
    _eventType = eventType;
  }

  EventType get eventType => _eventType;

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}

enum EventType {
  REFRESH_ALL_PAGES,
  REFRESH_HOME_PAGE,
  REFRESH_MAIN_PAGE,
  REFRESH_USER_DETAILS_PAGE,
  REFRESH_ACCEPT_ORDER_PAGE,
  REFRESH_VERIFICATION_PAGE,
  REFRESH_LOGIN_PAGE,
  REFRESH_PRINT_RECEIPT_PAGE,
  REFRESH_FEED_CONTAINER,
  SWITCH_TO_ORDER_NAVIGATION_PAGE
}
