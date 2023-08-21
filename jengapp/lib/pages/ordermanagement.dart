import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';
import 'package:jengapp/widgets/input_widget.dart';

import '../controllers/admin-order-controller.dart';
import '../models/order.dart';
import '../utils/helpers.dart';
import '../widgets/customicon.dart';
import '../widgets/dialogs.dart';
import '../widgets/orderprocess.dart';
import '../widgets/snackbar.dart';

class OrderManagement extends StatelessWidget {
  final AdminOrderController adminOrderController =
      Get.put(AdminOrderController());
  final TextEditingController amountTextEditingController =
      TextEditingController();
  final TextEditingController quantityTextEditingController =
      TextEditingController();
  final orderStatuses = [
    "Confirming",
    "Scheduled pick",
    "Processing",
    "Delivering",
    "Completed"
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAdminOrders().then((adminOrders) {
        adminOrderController.adminOrderList(adminOrders);
        adminOrderController.setAdminOrdersNotLoading();
      });
    });
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Constants.whiteColor,
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
              color: Constants.primaryColor,
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
                          Obx(() => Text(
                                "Order Management (" +
                                    adminOrderController.adminOrderList.length
                                        .toString() +
                                    ")",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              )),
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
                                adminOrderController.adminOrdersLoading.value
                                    ? Center(
                                        child: Text("Loading orders...",
                                            style: TextStyle(fontSize: 18)),
                                      )
                                    : adminOrderController
                                                .adminOrderList.length >
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
                                              return AdminOrderCard(
                                                  adminOrderController
                                                      .adminOrderList[index]);
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return SizedBox(
                                                height: 15.0,
                                              );
                                            },
                                            itemCount: adminOrderController
                                                .adminOrderList.length,
                                          )
                                        : Center(
                                            child: Text("No orders...",
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

  static Future<List<Order>?> getAdminOrders() async {
    String url = apiEndpoints.allOrders + "?position=3";
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      return null;
    }
  }

  Widget AdminOrderCard(Order order) {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/order_items", arguments: [
          {"orderID": order.orderID}
        ]);
      },
      child: Container(
        //height: ScreenUtil().setHeight(460.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Color.fromRGBO(220, 233, 245, 1),
          ),
        ),
        padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5, top: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getOrderIconWidget(order.orderStatus),
                SizedBox(
                  width: 25.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ORDER #" + order.orderID,
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        order.fullName.toUpperCase(),
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      if (order.isPickScheduled.compareTo("1") == 0)
                        Text(
                          "PICK TIME: " +
                              myDateFormat(order.scheduledPickDate)
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Constants.deepOrangeColor,
                            fontSize: 15.0,
                          ),
                        ),
                      SizedBox(
                        height: 5.0,
                      ),
                      textRow("Service", order.serviceType),
                      SizedBox(
                        height: 5.0,
                      ),
                      textRow(
                          "Date", myDateFormat(order.placedDate.toString())),
                      SizedBox(
                        height: 5.0,
                      ),
                      textRow(
                          "Quantity",
                          order.orderQuantity.toString() +
                              " " +
                              order.serviceUnits.toString() +
                              "" +
                              (double.parse(order.orderQuantity.toString()) > 1
                                  ? "s"
                                  : "")),
                      SizedBox(
                        height: 5.0,
                      ),
                      textRow("Amount",
                          forCurrencyString(order.orderAmount.toString())),
                      SizedBox(
                        height: 5.0,
                      ),
                      textRow("Order status", order.orderStatus.toString()),
                      SizedBox(
                        height: 5.0,
                      ),
                      textRow(
                          "Payment status",
                          order.orderPaymentStatus.toString().compareTo("0") ==
                                  0
                              ? "Unpaid"
                              : "Paid"),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      order.deliveryAddress,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            processTile(order.orderStatus.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                    //height: ScreenUtil().setHeight(190.0),
                    decoration: BoxDecoration(
                      color: Constants.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Color.fromRGBO(220, 233, 245, 1),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    child: Text(
                      "View Order | Add Items",
                      style: TextStyle(
                          fontSize: 16, color: Constants.secondaryColor),
                    )),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                myAdminButton("Chat", 10, 15, () {
                  launchWhatsapp("254"+(order.orderPhoneNumber.replaceFirst("0", "")));
                }),
                myAdminButton("Call", 10, 15, () {
                  makingPhoneCall(order.orderPhoneNumber);
                }),
                myAdminButton(
                    order.orderPaymentStatus.toString().compareTo("0") == 0
                        ? "set to Paid"
                        : "set to Unpaid",
                    10,
                    15, () {
                  setOrderPayStatus(order.orderID, order.orderPaymentStatus);
                }),
                myAdminButton("Delete", 10, 15, () {
                  deleteOrder(order.recordID);
                })
              ],
            ),
            Divider(
              height: 5,
              indent: 5,
              color: Constants.grayColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(
                      "New Status",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Obx(() => DropdownButton<String>(
                          // Step 3.
                          value: adminOrderController.selectedOrderStatus.value,
                          // Step 4.
                          items: orderStatuses
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.primaryColor),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                          // Step 5.
                          onChanged: (String? newValue) {
                            adminOrderController
                                .updateSelectedOrderStatus(newValue!);
                          },
                        )),
                  ],
                ),
                myAdminButton("Update Status", 10, 15, () {
                  setOrderStatus(order.orderID,
                      adminOrderController.selectedOrderStatus.value);
                }),
              ],
            ),
            Divider(
              height: 5,
              indent: 5,
              color: Constants.grayColor,
            ),
            SizedBox(
              height: 5,
            ),
            //adjust price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "New Amount",

                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedInputWidget(
                        hintText: order.orderAmount,
                        prefixIcon: FontAwesomeIcons.fonticons,
                        textEditingController: amountTextEditingController)
                  ],
                ),
                myAdminButton("Update Amount", 10, 15, () {
                  if (amountTextEditingController.text.isEmpty) {
                    showSnackBar("Provide valid value for amount");
                    return;
                  } else {
                    setOrderAmount(order.recordID,
                        amountTextEditingController.text.toString());
                  }
                }),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            //adjust weight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "New Weight",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedInputWidget(
                        hintText: order.orderQuantity,
                        prefixIcon: FontAwesomeIcons.fonticons,
                        textEditingController: quantityTextEditingController)
                  ],
                ),
                myAdminButton("Update Quantity", 10, 15, () {
                  if (quantityTextEditingController.text.isEmpty) {
                    showSnackBar("Provide valid value for quantity");
                    return;
                  } else {
                    setOrderActualQuantity(order.recordID,
                        quantityTextEditingController.text.toString());
                  }
                }),
              ],
            ),
            myAdminButton("View Invoice", 10, 15, () {
              Get.toNamed('/order-invoice', arguments: [
                {"orderID": order.orderID}
              ]);
            }),
          ],
        ),
      ),
    );
  }

  void deleteOrder(String recordID) {
    showConfirmationModalDialog(
        "Delete", "Do you want to delete the order?", "Delete", "Cancel", () {
      //showProgressDialog("Deleting", "Please hold..");
      //Get.back();
      var client = http.Client();
      client.delete(Uri.parse(apiEndpoints.deleteOrder), body: {
        "recordID": recordID,
      }).then((response) {
        client.close();

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['code'] == 1 || jsonResponse['code'] == 0) {
            Get.snackbar("Order", jsonResponse['message'],
                snackPosition: SnackPosition.BOTTOM,
                colorText: Constants.grayColor,
                backgroundColor: Constants.whiteColor,
                borderRadius: 10,
                icon: MyCustomIcon(
                    iconData: FontAwesomeIcons.check,
                    iconColor: Constants.secondaryColor,
                    containerColor: Constants.secondaryColorOpacity));
          }
        } else {
          serverError(response.statusCode.toString());
        }
        getAdminOrders().then((adminOrders) {
          adminOrderController.adminOrderList(adminOrders);
          adminOrderController.setAdminOrdersNotLoading();
        });
      });
      Get.back();
    });
  }

  void setOrderPayStatus(orderID, orderPaymentStatus) {
    showConfirmationModalDialog(
        "Payment Status", "Update payment status?", "Update", "Cancel", () {
      showProgressDialog("Payment", "Please hold..");
      Get.back();
      var client = http.Client();
      client.patch(Uri.parse(apiEndpoints.updatePayStatus), body: {
        "orderID": orderID,
        "status": orderPaymentStatus.toString().compareTo("0") == 0 ? "1" : "0",
      }).then((response) {
        client.close();

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['code'] == 1 || jsonResponse['code'] == 0) {
            Get.snackbar("Order", jsonResponse['message'],
                snackPosition: SnackPosition.BOTTOM,
                colorText: Constants.grayColor,
                backgroundColor: Constants.whiteColor,
                borderRadius: 10,
                icon: MyCustomIcon(
                    iconData: FontAwesomeIcons.check,
                    iconColor: Constants.secondaryColor,
                    containerColor: Constants.secondaryColorOpacity));
          }
        } else {
          serverError(response.statusCode.toString());
        }
        getAdminOrders().then((adminOrders) {
          adminOrderController.adminOrderList(adminOrders);
          adminOrderController.setAdminOrdersNotLoading();
        });
      });
      Get.back();
    });
  }

  void setOrderStatus(orderID, orderStatus) {
    showConfirmationModalDialog(
        "Order Status", "Update Order status?", "Update", "Cancel", () {
      showProgressDialog("Order status", "Please hold..");
      Get.back();
      var client = http.Client();
      client.patch(Uri.parse(apiEndpoints.updateOrderStatus), body: {
        "orderID": orderID,
        "status": orderStatus,
      }).then((response) {
        client.close();

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['code'] == 1 || jsonResponse['code'] == 0) {
            Get.snackbar("Order", jsonResponse['message'],
                snackPosition: SnackPosition.BOTTOM,
                colorText: Constants.grayColor,
                backgroundColor: Constants.whiteColor,
                borderRadius: 10,
                icon: MyCustomIcon(
                    iconData: FontAwesomeIcons.check,
                    iconColor: Constants.secondaryColor,
                    containerColor: Constants.secondaryColorOpacity));
          }
        } else {
          serverError(response.statusCode.toString());
        }
        getAdminOrders().then((adminOrders) {
          adminOrderController.adminOrderList(adminOrders);
          adminOrderController.setAdminOrdersNotLoading();
        });
      });
      Get.back();
    });
  }

  void setOrderAmount(recordID, Amount) {
    showConfirmationModalDialog(
        "Order Amount", "Update Order Amount?", "Update", "Cancel", () {
      showProgressDialog("Order Amount", "Please hold..");
      Get.back();
      var client = http.Client();
      client.patch(Uri.parse(apiEndpoints.updateOrderAmount), body: {
        "recordID": recordID,
        "amount": Amount,
      }).then((response) {
        client.close();

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['code'] == 1 || jsonResponse['code'] == 0) {
            Get.snackbar("Order", jsonResponse['message'],
                snackPosition: SnackPosition.BOTTOM,
                colorText: Constants.grayColor,
                backgroundColor: Constants.whiteColor,
                borderRadius: 10,
                icon: MyCustomIcon(
                    iconData: FontAwesomeIcons.check,
                    iconColor: Constants.secondaryColor,
                    containerColor: Constants.secondaryColorOpacity));
          }
        } else {
          serverError(response.statusCode.toString());
        }
        getAdminOrders().then((adminOrders) {
          adminOrderController.adminOrderList(adminOrders);
          adminOrderController.setAdminOrdersNotLoading();
        });
      });
      Get.back();
    });
  }

  void setOrderActualQuantity(recordID, Quantity) {
    showConfirmationModalDialog(
        "Order Quantity", "Update Quantity?", "Update", "Cancel", () {
      showProgressDialog("Order Quantity", "Please hold..");
      Get.back();
      var client = http.Client();
      client.patch(Uri.parse(apiEndpoints.updateOrderQuantity), body: {
        "recordID": recordID,
        "quantity": Quantity,
      }).then((response) {
        client.close();

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['code'] == 1 || jsonResponse['code'] == 0) {
            Get.snackbar("Order", jsonResponse['message'],
                snackPosition: SnackPosition.BOTTOM,
                colorText: Constants.grayColor,
                backgroundColor: Constants.whiteColor,
                borderRadius: 10,
                icon: MyCustomIcon(
                    iconData: FontAwesomeIcons.check,
                    iconColor: Constants.secondaryColor,
                    containerColor: Constants.secondaryColorOpacity));
          }
        } else {
          serverError(response.statusCode.toString());
        }
        getAdminOrders().then((adminOrders) {
          adminOrderController.adminOrderList(adminOrders);
          adminOrderController.setAdminOrdersNotLoading();
        });
      });
      Get.back();
    });
  }

  Widget textRow(String textOne, String textTwo) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$textOne:",
            style: TextStyle(
              color: Constants.grayColor,
              fontSize: 15.0,
            ),
          ),
          Spacer(),
          Text(
            textTwo,
            style: TextStyle(
              color: Color.fromRGBO(19, 22, 33, 1),
              fontSize: 15.0,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget getOrderIconWidget(status) {
    switch (status) {
      case "Scheduled pick":
        return MyCustomIcon(
          iconData: FontAwesomeIcons.clock,
          iconColor: Constants.primaryColor,
          containerColor: Constants.primaryColorOpacity,
        );
      case "Completed":
        return MyCustomIcon(
          iconData: FontAwesomeIcons.listCheck,
          iconColor: Constants.primaryColor,
          containerColor: Constants.primaryColorOpacity,
        );
      case "Confirming":
        return MyCustomIcon(
          iconData: Icons.add_shopping_cart_outlined,
          iconColor: Constants.primaryColor,
          containerColor: Constants.primaryColorOpacity,
        );
      case "Packaging":
        return MyCustomIcon(
          iconData: Icons.delivery_dining,
          iconColor: Constants.primaryColor,
          containerColor: Constants.primaryColorOpacity,
        );
      case "Delivering":
        return MyCustomIcon(
          iconData: Icons.delivery_dining,
          iconColor: Constants.primaryColor,
          containerColor: Constants.primaryColorOpacity,
        );
      case "Processing":
        return MyCustomIcon(
          iconData: Icons.local_laundry_service_outlined,
          iconColor: Constants.primaryColor,
          containerColor: Constants.primaryColorOpacity,
        );
      default:
        return MyCustomIcon(
          iconData: FontAwesomeIcons.clock,
          iconColor: Constants.secondaryColor,
          containerColor: Constants.secondaryColorOpacity,
        );
    }
  }
}
