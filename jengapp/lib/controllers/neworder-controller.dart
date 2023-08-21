import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/client.dart';

class NewOrderController extends GetxController {
  final units = 1.0.obs;
  final totalCost = 0.0.obs;
  final notSureOfQuantity = false.obs;
  final orderForClient = false.obs;
  final isPickScheduled = false.obs;
  final scheduledDate = "".obs;
  final selectedClientID = "20231".obs;
  final selectedClientName = "".obs;
  // final selectedItem = null.obs;
  final clientList = <Client>[].obs;
  Rx<TextEditingController> quantityEditingController=new TextEditingController().obs;

  void setUnits(unit,price) {
    units.value=double.parse(unit);
    print(units.value);
    totalCost.value = price * units.value;
  }
  void getTotalCost(price) {
    totalCost.value = price * units.value;
  }

  void updateNotSureOfQuantity(status, price) {
    notSureOfQuantity.value = status;
    if (status) {
      totalCost.value = 0;
      units.value = 0;
    } else {
      units.value = 7;
      totalCost.value = price * units.value;
    }
  }

  void updateIsPickScheduled(pickStatus) {
    isPickScheduled.value = pickStatus;
  }

  void updateOrderFOrClient(choice) {
    orderForClient.value = choice;
  }

  void updateScheduledDate(newDate) {
    scheduledDate.value = newDate;
  }

  void updateSelectedClientName(name) {
    //selectedClientID.value = ID;
    selectedClientID.value = name;
  }
  void updateSelectedClientID(id) {
    selectedClientID.value = id;

  }
  void updateClientList(clients){
    clientList.value=clients;
  }
}
