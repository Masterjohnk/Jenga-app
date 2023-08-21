class Item {
  final String recordID;
  final String itemName;
  final String itemQuantity;
  final String itemProperties;
  final String itemComment;

  Item({
    required this.recordID,
    required this.itemName,
    required this.itemQuantity,
    required this.itemProperties,
    required this.itemComment,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      recordID: json['recordID'].toString() ?? '',
      itemName: json['itemName'] ?? '',
      itemQuantity: json['itemQuantity'].toString() ?? '',
      itemProperties: json['itemProperties'] ?? '',
      itemComment: json['itemComments'] ?? '',
    );
  }

}
