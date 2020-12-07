class ClientEnum {
  //Response
  static final String RESPONSE_CONNECTION_ERROR = "CONNECTION_ERROR";
  static final String RESPONSE_SUCCESS = "success";
  static final String RESPONSE_FAIL = "fail";
  static final String RESPONSE_UNAUTHORIZED = "Unauthorized";

  static final String ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_PHARMA =
      "Pending Invoice Response From Pharma";
  static final String ORDER_STATUS_PENDING_INVOICE_RESPONSE_FROM_CUSTOMER =
      "Pending Invoice Response From CUSTOMER";
  static final String ORDER_STATUS_INVOICE_CONFIRM_FROM_CUSTOMER = "Invoice Confirm From Customer";
  static final String ORDER_STATUS_PROCESSING = "Processing";
  static final String ORDER_STATUS_ON_THE_WAY = "On the way";
  static final String ORDER_STATUS_DELIVERED = "Delivered";
  static final String ORDER_STATUS_CANCELED = "Canceled";
  static final String ORDER_STATUS_REJECTED = "Rejected";

  static final String ORDER_PAYMENT_STATUS_PAID = "Paid";
  static final String ORDER_PAYMENT_STATUS_NOT_PAID = "Not paid";

  static final String FEED_PENDING = "Pending";
  static final String FEED_CONFIRM = "Confirm";
  static final String FEED_CANCELED = "Canceled";
  static final String FEED_RETURNED = "Returned";
  static final String FEED_REJECTED = "Rejected";

  static final String FEED_ORDER = "ORDER FEED";

  static final String FEED_ITEM_ORDER_CARD = "Order Card";
  static final String FEED_ITEM_SEARCH_CARD = "Search Card";
}
