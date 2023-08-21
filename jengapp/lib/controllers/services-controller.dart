import 'package:get/get.dart';
import 'package:jengapp/models/service.dart';

class ServicesController extends GetxController {
  final servicesList = <Service>[].obs;
  final servicesLoading = true.obs;

  setServicesNotLoading() {
    servicesLoading.value = false;
  }

  void updateServicesList(services) {
    servicesList.value = services;

  }
}
