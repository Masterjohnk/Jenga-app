import 'dart:convert';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';
import 'package:jengapp/utils/helpers.dart';

import '../controllers/admin-dashboard-controller.dart';
import '../models/dashboard-data.dart';

class AdminDashboard extends StatelessWidget {
  final AdminDashboardController adminDashboardController =
      Get.put(AdminDashboardController());

  DateTime? startDate, endDate;

  // late double sales = 0.0, expenses = 0.0, profit = 0.0;
  var periodSelection;
  var items = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
    'Lifetime',
    'Date Range'
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    getAdminDashboardData().then((dashboardData) {
      adminDashboardController.setAdminDashboardNotLoading();
      adminDashboardController.updateAdminDashboard(dashboardData);

      // adminDashboardController.updateNumbers(
      //     double.parse(
      //         adminDashboardController.adminDashboardList[0].allSales),
      //     double.parse(
      //         adminDashboardController.adminDashboardList[0].allExpenses));
    });
     });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0.0,
            top: -20.0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                "assets/images/background.png",
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Admin Panel",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Constants.scaffoldBackgroundColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10.0,
                              ),

                              Obx(() => Column(
                                    children: [
                                      DropdownButton<String>(
                                        value: adminDashboardController
                                            .period.value,
                                        hint: Text(
                                          "Select Period",
                                          textAlign: TextAlign.center,
                                        ),
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: items.map((String trans) {
                                          return DropdownMenuItem(
                                              value: trans,
                                              child: Text(
                                                trans,
                                                // style: mainText(),
                                              ));
                                        }).toList(),
                                        onChanged: (String? period) {
                                          adminDashboardController
                                              .updatePeriod(period);
                                          if (adminDashboardController
                                                  .period.value
                                                  .compareTo("Date Range") ==
                                              0) {
                                            showCustomDateRangePicker(
                                              context,
                                              dismissible: false,
                                              minimumDate: DateTime.parse('2023-03-05'),
                                              maximumDate: DateTime.now(),
                                              endDate: endDate,
                                              startDate: startDate,
                                              backgroundColor: Colors.white,
                                              primaryColor:
                                                  Constants.primaryColor,
                                              onApplyClick: (start, end) {
                                                adminDashboardController
                                                    .setDates(DateFormat('yyyy-MM-dd').format(start), DateFormat('yyyy-MM-dd').format(end));
                                                if (!adminDashboardController
                                                    .adminDashboardLoading
                                                    .value) {
                                                  getAdminDashboardData()
                                                      .then((dashboardData) {
                                                    adminDashboardController
                                                        .setAdminDashboardNotLoading();
                                                    adminDashboardController
                                                        .updateAdminDashboard(
                                                            dashboardData);
                                                  });
                                                }
                                              },
                                              onCancelClick: () {
                                                adminDashboardController
                                                    .updatePeriod("Today");
                                                if (!adminDashboardController
                                                    .adminDashboardLoading
                                                    .value) {
                                                  getAdminDashboardData()
                                                      .then((dashboardData) {
                                                    adminDashboardController
                                                        .setAdminDashboardNotLoading();
                                                    adminDashboardController
                                                        .updateAdminDashboard(
                                                            dashboardData);
                                                  });
                                                }
                                              },
                                            );
                                          } else {
                                            if (!adminDashboardController
                                                .adminDashboardLoading.value) {
                                              getAdminDashboardData()
                                                  .then((dashboardData) {
                                                adminDashboardController
                                                    .setAdminDashboardNotLoading();
                                                adminDashboardController
                                                    .updateAdminDashboard(
                                                        dashboardData);
                                              });
                                            }
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: AdminDashWidgetCurrency(
                                                      "Profit",
                                                      double.parse(
                                                              adminDashboardController
                                                                  .adminDashboardList[
                                                                      0]
                                                                  .allSales
                                                                  .toString()) -
                                                          double.parse(
                                                              adminDashboardController
                                                                  .adminDashboardList[
                                                                      0]
                                                                  .allExpenses
                                                                  .toString()),
                                                      adminDashboardController
                                                          .period.value.compareTo("Date Range")==0?DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.startDate.value))+" to "+DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.endDate.value)):adminDashboardController
                                                          .period.value,
                                                      Constants
                                                          .primaryColorOpacity)),
                                            ]),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        endIndent: 20,
                                        indent: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: AdminDashWidgetCurrency(
                                                      "Income",
                                                      double.parse(
                                                          adminDashboardController
                                                              .adminDashboardList[
                                                                  0]
                                                              .allSales
                                                              .toString()),
                                                      adminDashboardController
                                                          .period.value.compareTo("Date Range")==0?DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.startDate.value))+" to "+DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.endDate.value)):adminDashboardController
                                                          .period.value,
                                                      Constants
                                                          .secondaryColorOpacity)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: AdminDashWidgetCurrency(
                                                      "Expenses",
                                                      double.parse(
                                                          adminDashboardController
                                                              .adminDashboardList[
                                                                  0]
                                                              .allExpenses
                                                              .toString()),
                                                      adminDashboardController
                                                          .period.value.compareTo("Date Range")==0?DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.startDate.value))+" to "+DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.endDate.value)):adminDashboardController
                                                          .period.value,
                                                      Constants
                                                          .secondaryColorOpacity)),
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: AdminDashWidget(
                                                      "Paid Orders",
                                                      int.parse(
                                                          adminDashboardController
                                                              .adminDashboardList[
                                                                  0]
                                                              .paidOrdersvalue
                                                              .toString()),
                                                      adminDashboardController
                                                          .period.value.compareTo("Date Range")==0?DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.startDate.value))+" to "+DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.endDate.value)):adminDashboardController
                                                          .period.value,
                                                      Constants
                                                          .secondaryColorOpacity)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: AdminDashWidget(
                                                      "Unpaid Orders",
                                                      int.parse(
                                                          adminDashboardController
                                                              .adminDashboardList[
                                                                  0]
                                                              .unPaidOrdersvalue
                                                              .toString()),
                                                      adminDashboardController
                                                          .period.value.compareTo("Date Range")==0?DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.startDate.value))+" to "+DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.endDate.value)):adminDashboardController
                                                          .period.value,
                                                      Constants
                                                          .secondaryColorOpacity)),
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: AdminDashWidget(
                                                      "Unique Orders",
                                                      int.parse(
                                                          adminDashboardController
                                                              .adminDashboardList[
                                                                  0]
                                                              .uniqueOrders
                                                              .toString()),
                                                      adminDashboardController
                                                          .period.value.compareTo("Date Range")==0?DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.startDate.value))+" to "+DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.endDate.value)):adminDashboardController
                                                          .period.value,
                                                      Constants
                                                          .secondaryColorOpacity)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: AdminDashWidgetCurrency(
                                                      "Amount Unpaid",
                                                      double.parse(
                                                          adminDashboardController
                                                              .adminDashboardList[
                                                                  0]
                                                              .moneyunpaid
                                                              .toString()),
                                                      adminDashboardController
                                                          .period.value.compareTo("Date Range")==0?DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.startDate.value))+" to "+DateFormat('dd-MM-yy').format(DateTime.parse(adminDashboardController.endDate.value)):adminDashboardController
                                                          .period.value,
                                                      Constants
                                                          .secondaryColorOpacity)),
                                            ]),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        endIndent: 20,
                                        indent: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: AdminDashAction(
                                                        "Customers",
                                                        Constants
                                                            .primaryColorOpacity,
                                                        () {
                                                      Get.toNamed(
                                                          '/all-customers');
                                                    })),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: AdminDashAction(
                                                        "Manage Orders",
                                                        Constants
                                                            .primaryColorOpacity,
                                                        () {
                                                      Get.toNamed(
                                                          '/order-management');
                                                    })),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: AdminDashAction(
                                                        "Manage Expenses",
                                                        Constants
                                                            .primaryColorOpacity,
                                                        () {
                                                      Get.toNamed('/expenses');
                                                    })),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ))

                              // Let's create an order model
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DashboardData>?> getAdminDashboardData() async {
    String opn = "";
    if (adminDashboardController.period.value.toString().compareTo("Today") ==
        0) {
      opn = "1";
    } else if (adminDashboardController.period.value
            .toString()
            .compareTo("This Week") ==
        0) {
      opn = "2";
    } else if (adminDashboardController.period.value
            .toString()
            .compareTo("This Month") ==
        0) {
      opn = "3";
    } else if (adminDashboardController.period.value
            .toString()
            .compareTo("This Year") ==
        0) {
      opn = "4";
    } else if (adminDashboardController.period.value
            .toString()
            .compareTo("Lifetime") ==
        0) {
      opn = "5";
    } else {
      opn = "6";
    }
    String url = apiEndpoints.getDashboardData +
        "?period=" +
        opn +
        "&startDate=" +
        adminDashboardController.startDate.toString() +
        "&endDate=" +
        adminDashboardController.endDate.toString();
    print(url);
    http.Response response;
    response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((alert) => DashboardData.fromJson(alert))
          .toList();
    } else {
      return null;
    }
  }

  Widget AdminDashWidgetCurrency(title, amount, comment, color) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      // color: Constants
      //     .primaryColorOpacity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              forCurrencyString(amount.toString()),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              comment,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,color: Constants.deepOrangeColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget AdminDashWidget(title, amount, comment, color) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      // color: Constants
      //     .primaryColorOpacity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              amount.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              comment,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,color: Constants.deepOrangeColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget AdminDashAction(title, color, action) {
    return GestureDetector(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        // color: Constants
        //     .primaryColorOpacity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      onTap: action,
    );
  }
}
