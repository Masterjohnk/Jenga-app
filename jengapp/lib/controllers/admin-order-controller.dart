import 'package:get/get.dart';
import 'package:jengapp/models/order.dart';

class AdminOrderController extends GetxController {

  final adminOrderList = <Order>[].obs;
  final adminOrdersLoading = true.obs;
  final selectedOrderStatus="Confirming".obs;

  setAdminOrdersNotLoading() {
    adminOrdersLoading.value = false;
  }
  updateAdminOrders(adminOrders) {
    adminOrderList.value = adminOrders;
  }
  updateSelectedOrderStatus(selected){
    selectedOrderStatus.value=selected;
  }

}
