import 'package:get/get.dart';
import 'package:jengapp/models/order.dart';
import 'package:jengapp/models/service.dart';

import '../models/promotion.dart';

class HomeScreenController extends GetxController {
  final menuIndex = 0.obs;
  final profileImage = "blank.png".obs;
  final servicesList = <Service>[].obs;
  final promotionList = <Promotion>[].obs;
  final recentOrderList = <Order>[].obs;
  final scheduledOrderList = <Order>[].obs;
  final allOrderList = <Order>[].obs;
  final allOrdersLoading = true.obs;
  final servicesLoading = true.obs;
  final scheduledOrdersLoading = true.obs;

  setAllOrdersNotLoading() {
    allOrdersLoading.value = false;
  }

  setScheduledOrdersNotLoading() {
    scheduledOrdersLoading.value = false;
  }
  setServicesNotLoading() {
    servicesLoading.value = false;
  }
  void updateMenuIndex(index) {
    menuIndex.value = index;
  }

  void updateProfileImage(image) {
    profileImage.value = image;
  }

  void updateServicesList(services) {
    servicesList.value = services;
    servicesLoading.value=false;
  }

  void updatePromotionList(promotions) {
    promotionList.value = promotions;
  }

  updateRecentOrders(recentOrders) {
    recentOrderList.value = recentOrders;
  }

  updateAllOrders(allOrders) {
    allOrderList.value = allOrders;
  }

  updateScheduledOrders(scheduleOrders) {
    scheduledOrderList.value = scheduleOrders;
  }
}
