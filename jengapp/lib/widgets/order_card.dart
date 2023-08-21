import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jengapp/models/order.dart';
import 'package:jengapp/utils/constants.dart';

import '../utils/helpers.dart';
import 'customicon.dart';
import 'orderprocess.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/order_items", arguments: [
          {"orderID": order.orderID}
        ]);
      },
      child: Container(
        //height: ScreenUtil().setHeight(360.0),
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
                        height: 10.0,
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
                      "View Order Items",
                      style: TextStyle(fontSize: 16),
                    )),

              ],
            ),
            SizedBox(height: 5),
            myAdminButton("View Invoice", 10, 15, () {
              Get.toNamed('/order-invoice',arguments: [
                {"orderID": order.orderID}]);
            }),
          ],
        ),
      ),
    );
  }
}

Widget textRow(String textOne, String textTwo) {
  return Padding(
    padding: const EdgeInsets.only(right: 20.0),
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

class IndicatorExample extends StatelessWidget {
  const IndicatorExample({Key? key, required this.number}) : super(key: key);

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 4,
          ),
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
