import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jengapp/models/dashboard-data.dart';

class AdminDashboardController extends GetxController {
  final adminDashboardList = <DashboardData>[].obs;
  final adminDashboardLoading = true.obs;
  final sales = 0.0.obs;
  final expenses = 0.0.obs;
  final period = "Today".obs;
  final startDate=DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  final endDate=DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
   setAdminDashboardNotLoading() {
    adminDashboardLoading.value = false;
  }

  updateAdminDashboard(adminOrders) {
    adminDashboardList.value = adminOrders;
  }

  updatePeriod(Period) {
    period.value = Period;

  }
  setDates(sDate,eDate){
    startDate.value=sDate;
    endDate.value=eDate;

    print("Date: "+startDate.value.toString());
  }
  updateNumbers(sale, expense) {
    sales.value = sale;
    expenses.value = expense;
  }
}
