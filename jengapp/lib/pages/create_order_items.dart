import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jengapp/controllers/logincontroller.dart';
import 'package:jengapp/controllers/order-item-controller.dart';
import 'package:jengapp/models/order-item.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';

import '../models/clothe-type.dart';
import '../utils/helpers.dart';
import '../utils/prefs.dart';
import '../widgets/customicon.dart';
import '../widgets/dialogs.dart';
import '../widgets/input_widget.dart';

class OrderItems extends StatelessWidget {
  final OrderItemListController orderItemListController =
      Get.put(OrderItemListController());
  final LoginController loginController = Get.put(LoginController());
  final Prefs _prefs = Prefs();

  //final NewOrderController newOrderController = Get.put(NewOrderController());
  TextEditingController propertyTextEditingController = TextEditingController();
  TextEditingController commentTextEditingController = TextEditingController();
  final orderID = Get.arguments[0]['orderID'];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefs.getStringValuesSF("role").then((rem) {
        loginController.updateUserRole(rem);
      });

      getAllOrderItems().then((allOrderItems) {
        orderItemListController.updateOrderItemList(allOrderItems);
        orderItemListController.setOrderItemListNotLoading();
      });
      getAllClothTypes().then((allClotheTypes) {
        orderItemListController.updateClothesType(allClotheTypes);
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
                          Text(
                            "Order #" + orderID + " Items",
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
                        if (loginController.userRole.value
                                .toString()
                                .compareTo("1") ==
                            0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Add items to order",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Constants.primaryColor,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        if (loginController.userRole.value
                                .toString()
                                .compareTo("1") ==
                            0)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 30),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Item",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Obx(() => DropdownButton<String>(
                                              // Step 3.
                                              value: orderItemListController
                                                  .selectedClothType.value,
                                              // Step 4.
                                              items: orderItemListController
                                                  .clothesType
                                                  .map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (ClothType value) {
                                                return DropdownMenuItem<String>(
                                                  value: value.clothe,
                                                  child: Text(
                                                    value.clothe,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Constants
                                                            .primaryColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                              }).toList(),
                                              // Step 5.
                                              onChanged: (String? newValue) {
                                                orderItemListController
                                                    .updateSelectedClothType(
                                                        newValue!);
                                              },
                                            )),
                                      ],
                                    ),
                                    Obx(
                                      () => Row(
                                        children: [
                                          orderItemListController.units != 1
                                              ? GestureDetector(
                                                  child: Container(
                                                    width: ScreenUtil()
                                                        .setWidth(30.0),
                                                    height: ScreenUtil()
                                                        .setHeight(30.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Constants
                                                          .primaryColor
                                                          .withOpacity(.3),
                                                    ),
                                                    child: Icon(
                                                      FontAwesomeIcons.minus,
                                                      color: Constants
                                                          .secondaryColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  onTap: () =>
                                                      orderItemListController
                                                          .decreaseUnits(),
                                                )
                                              : Container(),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '${orderItemListController.units}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          GestureDetector(
                                              child: Container(
                                                width:
                                                    ScreenUtil().setWidth(30.0),
                                                height: ScreenUtil()
                                                    .setHeight(30.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Constants.primaryColor
                                                      .withOpacity(.3),
                                                ),
                                                child: Icon(
                                                  FontAwesomeIcons.plus,
                                                  color:
                                                      Constants.secondaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                              onTap: () {
                                                orderItemListController
                                                    .increaseUnits();
                                              })
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InputWidget(
                                      prefixIcon: FontAwesomeIcons.penRuler,
                                      topLabel: "Item Property",
                                      hintText: "E.g color, material etc",
                                      textEditingController:
                                          propertyTextEditingController,
                                    ),
                                    InputWidget(
                                      prefixIcon: FontAwesomeIcons.comment,
                                      topLabel: "Item Comment",
                                      hintText: "E.g stained, torn etc",
                                      textEditingController:
                                          commentTextEditingController,
                                    ),
                                  ],
                                ),
                                myAdminButton("Add Item", 10, 15, () {
                                  addOrderItems(
                                      orderID,
                                      orderItemListController
                                          .selectedClothType.value,
                                      orderItemListController.units.value,
                                      propertyTextEditingController.text
                                          .toString(),
                                      commentTextEditingController.text
                                          .toString());
                                }),
                                Divider(
                                  indent: 25,
                                  endIndent: 25,
                                ),
                              ],
                            ),
                          ),
                        Obx(
                          () => Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40,
                                      child: Text("No.",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Constants.primaryColor),
                                          textAlign: TextAlign.start),
                                    ),
                                    Container(
                                      width: 130,
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Constants.primaryColor),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      width: 130,
                                      child: Text(
                                        "Property",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Constants.primaryColor),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      child: Text(
                                        "Qty",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Constants.primaryColor),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    if (loginController.userRole.value
                                            .toString()
                                            .compareTo("1") ==
                                        0)
                                      Container(
                                        width: 20,
                                        child: Icon(
                                          Icons.delete,
                                          color: Constants.primaryColor,
                                        ),
                                      ),
                                  ],
                                ),
                                Divider(
                                  indent: 25,
                                  endIndent: 25,
                                ),
                                orderItemListController
                                        .orderItemListLoading.value
                                    ? Center(
                                        child: Text("Loading order items...",
                                            style: TextStyle(fontSize: 18)),
                                      )
                                    : orderItemListController
                                                .orderItemList.length >
                                            0
                                        ? Column(children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 10.0,
                                              ),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                // Lets pass the order to a new widget and render it there
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          child: Text(
                                                              (index + 1)
                                                                      .toString() +
                                                                  ". ",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                        ),
                                                        Container(
                                                          width: 130,
                                                          child: Text(
                                                            orderItemListController
                                                                .orderItemList[
                                                                    index]
                                                                .itemName,
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 130,
                                                          child: Text(
                                                            orderItemListController
                                                                .orderItemList[
                                                                    index]
                                                                .itemProperties,
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          child: Text(
                                                            orderItemListController
                                                                .orderItemList[
                                                                    index]
                                                                .itemQuantity,
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        if (loginController
                                                                .userRole.value
                                                                .toString()
                                                                .compareTo(
                                                                    "1") ==
                                                            0)
                                                          Container(
                                                            width: 20,
                                                            child:
                                                                GestureDetector(
                                                              child: Icon(
                                                                  Icons.delete),
                                                              onTap: () => deleteOrderItem(
                                                                  orderItemListController
                                                                      .orderItemList[
                                                                          index]
                                                                      .recordID),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    if (orderItemListController
                                                        .orderItemList[index]
                                                        .itemComment
                                                        .isNotEmpty)
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 55,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              orderItemListController
                                                                  .orderItemList[
                                                                      index]
                                                                  .itemComment,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Constants
                                                                      .grayColor),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return SizedBox(
                                                  height: 5.0,
                                                );
                                              },
                                              itemCount: orderItemListController
                                                  .orderItemList.length,
                                            ),
                                            Divider(
                                              indent: 25,
                                              endIndent: 25,
                                            ),
                                            Text(
                                              "Number of items: " +
                                                  getItemCount(
                                                          orderItemListController
                                                              .orderItemList
                                                              .value)
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  "In case the information conflicts with your expectation please let us know immediately",
                                                  style: TextStyle(
                                                      color: Constants
                                                          .deepOrangeColor),
                                                )),
                                          ])
                                        : Center(
                                            child: Text("No order items...",
                                                style: TextStyle(fontSize: 18)),
                                          ),

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

  Future<List<Item>?> getAllOrderItems() async {
    String url = apiEndpoints.allOrderItems + "?orderID=" + orderID;
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      return null;
    }
  }

  Future<List<ClothType>?> getAllClothTypes() async {
    String url = apiEndpoints.allClotheTypes;
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => ClothType.fromJson(item)).toList();
    } else {
      return null;
    }
  }

  getItemCount(List<Item> orderItemList) {
    late int itemCount = 0;
    for (var i = 0; i < orderItemList.length; i++) {
      itemCount =
          itemCount + int.parse(orderItemList[i].itemQuantity.toString());
    }
    int total = itemCount;
    return total;
  }

  void deleteOrderItem(recordID) {
    showConfirmationModalDialog(
        "Delete Item", "Delete order item?", "Delete", "Cancel", () {
      //showProgressDialog("Deleting", "Please hold..");
      //Get.back();
      var client = http.Client();
      client.delete(
          Uri.parse(apiEndpoints.deleteOrderItem + "?recordID=" + recordID),
          body: {
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
        getAllOrderItems().then((allOrderItems) {
          orderItemListController.updateOrderItemList(allOrderItems);
          orderItemListController.setOrderItemListNotLoading();
        });
      });
      Get.back();
    });
  }

  void addOrderItems(String orderID, String selectedClothType, double units,
      String property, String comment) {
    //showProgressDialog("Deleting", "Please hold..");
    //Get.back();
    var client = http.Client();
    client.post(Uri.parse(apiEndpoints.addOrderItem), body: {
      "orderID": orderID.toString(),
      "clotheType": selectedClothType,
      "quantity": units.toString(),
      "property": property,
      "comment": comment,
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
      getAllOrderItems().then((allOrderItems) {
        orderItemListController.updateOrderItemList(allOrderItems);
        orderItemListController.setOrderItemListNotLoading();
      });
    });
    //Get.back();
    commentTextEditingController.text = "";
    propertyTextEditingController.text = "";
    orderItemListController.initializeUnits();
  }
}
