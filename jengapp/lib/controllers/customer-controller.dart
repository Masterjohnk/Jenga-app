import 'package:get/get.dart';
import 'package:jengapp/models/customer.dart';

class CustomerController extends GetxController {
  final customerList = <Customer>[].obs;
  final customerLoading=true.obs;

  updateAllCustomers(allCustomers) {
    customerList.value = allCustomers;
  }
  setCustomerNotLoading() {
    customerLoading.value = false;
  }
}
