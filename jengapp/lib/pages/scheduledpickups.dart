import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';

import '../controllers/homescreen-controller.dart';
import '../controllers/logincontroller.dart';
import '../models/order.dart';
import '../widgets/scheduled_order_card.dart';

class SchedulePickups extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final HomeScreenController dashController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getScheduledOrders().then((scheduledOrders) {
        dashController.scheduledOrderList(scheduledOrders);
        dashController.setScheduledOrdersNotLoading();
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
                          Text(
                            "Scheduled pickups",
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
                        Obx(
                          () => Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                dashController.scheduledOrdersLoading.value
                                    ? Center(
                                        child: Text(
                                            "Loading scheduled deliveries...",
                                            style: TextStyle(fontSize: 18)),
                                      )
                                    : dashController.scheduledOrderList.length >
                                            0
                                        ? ListView.separated(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 10.0,
                                            ),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              // Lets pass the order to a new widget and render it there
                                              return ScheduledOrderCard(
                                                order: dashController
                                                    .scheduledOrderList[index],
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return SizedBox(
                                                height: 15.0,
                                              );
                                            },
                                            itemCount: dashController
                                                .scheduledOrderList.length,
                                          )
                                        : Center(
                                            child: Text(
                                                "No scheduled deliveries...",
                                                style: TextStyle(fontSize: 18)),
                                          )
                                // Let's create an order model
                              ],
                            ),
                          ),
                        )
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

  Future<List<Order>?> getScheduledOrders() async {
    String url = apiEndpoints.allOrders +
        "?position=2&customerID=" +
        loginController.customerID.value;
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      return null;
    }
  }
}
