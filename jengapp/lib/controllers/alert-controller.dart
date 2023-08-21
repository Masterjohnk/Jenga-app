import 'package:get/get.dart';

import '../models/alert.dart';

class AlertController extends GetxController {
  final alertList = <Alert>[].obs;
  final alertLoading=true.obs;

  updateAllAlerts(allAlerts) {
    alertList.value = allAlerts;
  }
  setAlertNotLoading() {
    alertLoading.value = false;
  }
}
