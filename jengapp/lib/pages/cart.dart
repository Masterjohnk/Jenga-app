import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jengapp/models/order_item.dart';
import 'package:jengapp/pages/dashboard.dart';
import 'package:jengapp/pages/profile.dart';
import 'package:jengapp/utils/CartDBOperations.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';
import 'package:jengapp/widgets/sized_app_button.dart';
import '../controllers/cart-controller.dart';
import '../controllers/logincontroller.dart';
import '../controllers/neworder-controller.dart';
import '../utils/helpers.dart';
import '../widgets/dialogs.dart';
import '../widgets/snackbar.dart';
import 'package:http/http.dart' as http;

class Cart extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final OrderController orderController = Get.put(OrderController());
  final NewOrderController newOrderController = Get.put(NewOrderController());
  late final CartDBOperations myCart = CartDBOperations();

  @override
  Widget build(BuildContext context) {
    myCart.openDataBase().then((op) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        myCart.openDataBase();
        getAllOrders().then((allOrders) {
          orderController.updateAllOrdersItems(allOrders);
          orderController.setOrderNotLoading();
          double cartTotal = 0.0;
          int cartItemCount = 0;
          for (var j in orderController.cartList) {
            cartTotal = cartTotal + (double.tryParse(j.amount) ?? 0.0);
            cartItemCount = cartItemCount + (int.tryParse(j.quantity) ?? 0);
          }

          orderController.setCartTotals(cartItemCount, cartTotal);
        });
      });
    });
    return Obx(() => Scaffold(
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
                                "Cart" ,
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
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  orderController.cartListLoading.value
                                      ? Center(
                                          child: Text("Loading cart...",
                                              style: TextStyle(fontSize: 18)),
                                        )
                                      : orderController.cartList.length > 0
                                          ? Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Card(
                                                    shadowColor:
                                                    Constants.secondaryColor,
                                                    elevation: 4,
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                "Cart Items " +
                                                                    orderController
                                                                        .cartItemNumber
                                                                        .value
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 20),
                                                              ),
                                                              Text(
                                                                "Total Kshs " +
                                                                    orderController
                                                                        .cartTotal
                                                                        .value
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 20),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              SizedAppButton(
                                                                  type:
                                                                  SizedButtonType
                                                                      .PRIMARY,
                                                                  onPressed: () async {
                                                                    int success=0;
                                                                    showProgressDialog("Ordering", "Please hold..");
                                                                    var client = http.Client();
                                                                    for(var orderItem in orderController.cartList){
                                                                      await client.post(Uri.parse(apiEndpoints.createOrder), body: {
                                                                        "customerID": newOrderController.orderForClient.value
                                                                            ? newOrderController.selectedClientID.value
                                                                            : loginController.customerID.toString(),
                                                                        "serviceID": orderItem.serviceID.toString(),
                                                                        "createdBy": loginController.customerID.toString(),
                                                                        "approximateQuantity": newOrderController.units.toString(),
                                                                        "amount": orderItem.amount.toString(),
                                                                        "isPickScheduled": newOrderController.isPickScheduled.value ? "1" : "0",
                                                                        "scheduledPickDate": newOrderController.scheduledDate.value,
                                                                        "comments": "",
                                                                      }).then((response) {
                                                                        print(response.body);
                                                                        Get.back();
                                                                        //client.close();
                                                                        if (response.statusCode == 200) {
                                                                          var jsonResponse = json.decode(response.body);
                                                                          if (jsonResponse['code'] == 1 || jsonResponse['code'] == 0) {
                                                                            success=1;
                                                                            // showConfirmationModalDialog(
                                                                            //     "Order", jsonResponse['message'], "Okay", "Cancel", () {
                                                                            //   newOrderController.updateIsPickScheduled(false);
                                                                            //   //Get.toNamed('/homescreen');
                                                                            // });
                                                                          }
                                                                        } else {
                                                                          serverError(response.statusCode.toString());
                                                                        }
                                                                      });

                                                                    }
                                                                    myCart.deleteAll();
                                                                    getAllOrders().then((allOrders) {
                                                                      orderController.updateAllOrdersItems(allOrders);
                                                                      orderController.setOrderNotLoading();
                                                                      double cartTotal = 0.0;
                                                                      int cartItemCount = 0;
                                                                      for (var j in orderController.cartList) {
                                                                        cartTotal = cartTotal + (double.tryParse(j.amount) ?? 0.0);
                                                                        cartItemCount = cartItemCount + (int.tryParse(j.quantity) ?? 0);
                                                                      }

                                                                      orderController.setCartTotals(cartItemCount, cartTotal);
                                                                      if(success==1) {
                                                                        showConfirmationModalDialog(
                                                                            "Order",
                                                                            "Order placed successfuly. We will call you to confirm it",
                                                                            "Okay",
                                                                            "Cancel", () {
                                                                          newOrderController
                                                                              .updateIsPickScheduled(
                                                                              false);
                                                                          Get.toNamed('/homescreen');
                                                                        });
                                                                      }
                                                                    });







                                                                  },
                                                                  text: "Place order")
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Column(
                                                            children: [
                                                              SizedAppButton(
                                                                  type:
                                                                  SizedButtonType
                                                                      .PLAIN,
                                                                  onPressed: () {
                                                                    Get.offAndToNamed('/homescreen');
                                                                  },
                                                                  text: "Shop more"),
                                                              SizedBox(height: 10,),
                                                              SizedAppButton(
                                                                  type:
                                                                  SizedButtonType
                                                                      .SECONDARY,
                                                                  onPressed: () {
                                                                    Get.to(() => Profile());
                                                                  },
                                                                  text: "Update address")
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ListView.builder(
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
                                                    return Obx(
                                                      () => orderController
                                                              .cartListLoading()
                                                          ? Container(
                                                              child: Text(
                                                                  "Loading"),
                                                            )
                                                          : Container(
                                                              //height: ScreenUtil().setHeight(145.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                border:
                                                                    Border.all(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          220,
                                                                          233,
                                                                          245,
                                                                          1),
                                                                ),
                                                              ),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                      vertical:
                                                                          16.0),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            60,
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: apiEndpoints.serviceImages + orderController.cartList[index].serviceImage,
                                                                            fit: BoxFit.cover,
                                                                            placeholder: (context, url) => Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                      width: 5,
                                                                                      child: CircularProgressIndicator(
                                                                                        color: Constants.primaryColor,
                                                                                        strokeWidth: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),

                                                                            // You can use LinearProgressIndicator or CircularProgressIndicator instead

                                                                            errorWidget: (context, url, error) {
                                                                              return Image.asset("assets/images/blank.png");
                                                                            }),
                                                                      ),
                                                                      //getAlertIconWidget(orderItem.serviceID),
                                                                      SizedBox(
                                                                        width:
                                                                            15.0,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  orderController.cartList[index].serviceName,
                                                                                  style: TextStyle(
                                                                                    color: Constants.primaryColor,
                                                                                    fontSize: 16.0,
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                Text(
                                                                                  "Kshs " + orderController.cartList[index].amount.toString().toUpperCase(),
                                                                                  style: TextStyle(
                                                                                    color: Constants.primaryColor,
                                                                                    fontSize: 16.0,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 3.0,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  orderController.cartList[index].quantity + " " + orderController.cartList[index].serviceUnits,
                                                                                  style: TextStyle(
                                                                                    color: Constants.grayColor,
                                                                                    fontSize: 16.0,
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                GestureDetector(
                                                                                  child: Icon(
                                                                                    Icons.delete,
                                                                                    color: Constants.secondaryColor,
                                                                                    size: 30,
                                                                                  ),
                                                                                  onTap: () {
                                                                                    myCart.deleteSpecific(orderController.cartList[index].recID);
                                                                                    getAllOrders().then((allOrders) {
                                                                                      orderController.updateAllOrdersItems(allOrders);
                                                                                      orderController.setOrderNotLoading();
                                                                                      double cartTotal = 0.0;
                                                                                      int cartItemCount = 0;
                                                                                      for (var j in orderController.cartList) {
                                                                                        cartTotal = cartTotal + (double.tryParse(j.amount) ?? 0.0);
                                                                                        cartItemCount = cartItemCount + (int.tryParse(j.quantity) ?? 0);
                                                                                      }

                                                                                      orderController.setCartTotals(cartItemCount, cartTotal);
                                                                                    });
                                                                                    showSnackBar("Item removed from cart");
                                                                                  },
                                                                                )
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 1.0,
                                                                            ),
                                                                            // textRow("Service type", order.serviceType),
                                                                            // SizedBox(
                                                                            //   height: 5.0,
                                                                            // ),
                                                                            // Text(
                                                                            //   myDateFormat(orderItem.activityTime.toString()),
                                                                            //   style: TextStyle(
                                                                            //     color: Color.fromRGBO(19, 22, 33, 1),
                                                                            //     fontSize: 15.0,
                                                                            //   ),
                                                                            //   textAlign: TextAlign.end,
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                    );
                                                  },
                                                  // separatorBuilder:
                                                  //     (BuildContext context,
                                                  //         int index) {
                                                  //   return SizedBox(
                                                  //     height: 3.0,
                                                  //   );
                                                  // },
                                                  itemCount: orderController
                                                      .cartList.length,
                                                ),

                                              ],
                                            )
                                          : Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Your cart is empty...",
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  myAdminButton(
                                                      "Shop Now", 10, 10, () {
                                                    Get.to(() => Dashboard());
                                                  }),
                                                ],
                                              ),
                                            )
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
        ));
  }

  Future<List<OrderItem>?> getAllOrders() async {
    var cartItemList = myCart.getCartItems();
    return cartItemList;
  }
}
