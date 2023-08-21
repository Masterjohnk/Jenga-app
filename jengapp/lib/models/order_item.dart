class OrderItem {
  final String recID;
  final String serviceID;
  final String serviceName;
  final String serviceImage;
  final String amount;
  final String quantity;
  final String serviceUnits;

  OrderItem( {
    required this.recID,
    required this.serviceID,
    required this.serviceName,
    required this.serviceImage,
    required this.amount,
    required this.quantity,
    required this.serviceUnits,
  });

  // factory OrderItem.fromJson(Map<String, dynamic> json) {
  //   return OrderItem(
  //     recID:json['id'] ?? '',
  //     serviceID: json['type'] ?? '',
  //     amount: json['category'] ?? '',
  //     quantity: json['description'].toString() ?? '',
  //     serviceName: json['description'].toString() ?? '',
  //   );
  // }
}
