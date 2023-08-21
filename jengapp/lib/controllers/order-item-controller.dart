import 'package:get/get.dart';
import 'package:jengapp/models/clothe-type.dart';

import '../models/order-item.dart';

class OrderItemListController extends GetxController {
  final orderItemList = <Item>[].obs;
  final clothesType = <ClothType>[].obs;
  final orderItemListLoading = true.obs;
  final selectedClothType = "Tops".obs;
  final units = 1.0.obs;

  updateOrderItemList(allOrderItems) {
    orderItemList.value = allOrderItems;
  }

  updateClothesType(clotheTypes) {
    clothesType.value = clotheTypes;
  }

  setOrderItemListNotLoading() {
    orderItemListLoading.value = false;
  }

  updateSelectedClothType(cloth) {
    selectedClothType.value = cloth;
  }

  increaseUnits() {
    units.value++;
  }

  decreaseUnits() {
    if (units.value > 1) {
      units.value--;
    }
  }

  initializeUnits() {
    {
      units.value = 1;
    }
  }
}
