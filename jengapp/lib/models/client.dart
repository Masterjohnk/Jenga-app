class Client {
  final String firstName;
  final String secondName;
  final String customerID;

  Client({
    required this.firstName,
    required this.secondName,
    required this.customerID,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      firstName: json['fname'] ?? '',
      secondName: json['lname'] ?? '',
      customerID: json['memberID'].toString() ?? '',
    );
  }
}
