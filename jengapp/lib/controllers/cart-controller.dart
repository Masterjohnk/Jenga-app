import 'package:get/get.dart';
import 'package:jengapp/models/order_item.dart';

class OrderController extends GetxController {
  final cartList = <OrderItem>[].obs;
  final cartListLoading = true.obs;
  final cartItemNumber = 0.obs;
  final cartTotal = 0.0.obs;

  updateAllOrdersItems(allAlerts) {
    cartList.value = allAlerts;
  }

  setOrderNotLoading() {
    cartListLoading.value = false;
  }

  setCartTotals(int items, double total) {
    cartItemNumber.value = items;
    cartTotal.value = total;
  }
}
