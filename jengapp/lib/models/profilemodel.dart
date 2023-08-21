class ProfileData {
  final String firstName;
  final String secondName;
  final String address;
  final String phone;
  final String email;
  final String customerID;
  final String profilePic;

  ProfileData({
    required this.phone,
    required this.email,
    required this.firstName,
    required this.secondName,
    required this.address,
    required this.customerID,
    required this.profilePic,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      firstName: json['fname'] ?? '',
      customerID: json['memberID'].toString() ?? '',
      profilePic: json['image'] ?? '',
      secondName: json['lname'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
