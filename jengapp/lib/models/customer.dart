class Customer {
  final String customerID;
  final String fname;
  final String lname;
  final String phone;
  final String image;
  final String address;
  final String ltvamount;
  final String ltvcount;

  Customer({
    required this.customerID,
    required this.fname,
    required this.lname,
    required this.phone,
    required this.image,
    required this.address,
    required this.ltvamount,
    required this.ltvcount,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      phone: json['phone'].toString() ?? '',
      image: json[' image'] ?? '',
      address: json['address'] ?? '',
      ltvamount: json['ltv_amount'].toString() ?? '',
      ltvcount: json['ltv_count'].toString() ?? '',
      customerID: json['customerID'] .toString()?? '',
    );
  }
}
