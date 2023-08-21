import 'package:get/get.dart';

class LoginController extends GetxController {
  final firstName = "".obs;
  final customerID = "".obs;
  final userRole = "0".obs;
  final deviceID="".obs;
  final remPassword=false.obs;

  void updateUserDetails(name) {
    firstName.value = name;
  }

  void updateCustomerID(ID) {
    customerID.value = ID;
  }
  void updateUserRole(role) {
    userRole.value = role;
  }
  void updateDeviceID(deviceId) {
    deviceID.value = deviceId;
  }
  void updateRememberPassword(choice) {
    remPassword.value = choice;
  }
}
