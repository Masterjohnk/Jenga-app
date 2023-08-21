class Order {
  final String recordID;
  final String orderID;
  final String orderPhoneNumber;
  final String serviceType;
  final String orderStatus;
  final String orderPaymentStatus;
  final String orderAmount;
  final String orderQuantity;
  final String isPickScheduled;
  final String placedDate;
  final String scheduledPickDate;
  final String deliveryAddress;
  final String fullName;
  final String serviceUnits;

  Order(  {
    required this.recordID,
    required this.orderID,
    required this.serviceType,
    required this.orderStatus,
    required this.orderAmount,
    required this.placedDate,
    required this.scheduledPickDate,
    required this.orderPaymentStatus,
    required this.deliveryAddress,
    required this.isPickScheduled,
    required this.orderPhoneNumber,
    required this.fullName,
    required this.orderQuantity,
    required this.serviceUnits,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderID: json['orderID'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      orderAmount: json['amount'].toString() ?? '',
      placedDate: json['createdDate'] ?? '',
      deliveryAddress: json['address'] ?? '',
      serviceType: json['serviceName'] ?? '',
      orderPaymentStatus: json['isPaid'].toString() ?? '',
      scheduledPickDate: json['scheduledPickDate'] ?? '',
      isPickScheduled: json['isPickScheduled'].toString() ?? '',
      orderPhoneNumber: json['phone'].toString() ?? '',
      fullName: json['fname'].toString() + " " + json['lname'].toString() ?? '',
      recordID: json['rid'].toString() ?? '',
      orderQuantity: json['actualQuantity'].toString() ?? '',
      serviceUnits: json['serviceUnits'].toString() ?? '',
    );
  }
}
