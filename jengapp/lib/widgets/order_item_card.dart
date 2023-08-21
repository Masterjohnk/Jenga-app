import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';

import '../controllers/cart-controller.dart';
import '../controllers/services-controller.dart';
import '../models/order_item.dart';
import '../models/service.dart';
import '../utils/CartDBOperations.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItem orderItem;
  late final CartDBOperations myCart = CartDBOperations();
  final OrderController orderController = Get.put(OrderController());


  final ServicesController servicesController = Get.put(ServicesController());

  OrderItemCard({required this.orderItem});

  Widget build(BuildContext context) {
    myCart.openDataBase();
    getServices(orderItem.serviceID).then((services) {
      servicesController.updateServicesList(services);
      servicesController.setServicesNotLoading();

    });
    return Obx(() => servicesController.servicesLoading() || servicesController.servicesList.length<0 ?Container(
      child: Text("Loading"),
    ):Container(
              //height: ScreenUtil().setHeight(145.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Color.fromRGBO(220, 233, 245, 1),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CachedNetworkImage(
                            imageUrl: apiEndpoints.serviceImages +
                                servicesController
                                    .servicesList[0].serviceImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
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
                        width: 15.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  servicesController.servicesList[0].serviceName
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Constants.primaryColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Spacer(),
                                Text("Kshs "+
                                  orderItem.amount
                                      .toString()
                                      .toUpperCase(),
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
                                  orderItem.quantity+" "+ servicesController.servicesList[0].serviceUnits,
                                  style: TextStyle(
                                    color: Constants.grayColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(child: Icon(Icons.delete, color: Constants.secondaryColor,size: 30,),onTap:(){
                                  myCart.deleteSpecific(orderItem.recID);


    }
                                  ,)

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
  }

  static Future<List<Service>?> getServices(orderItemID) async {
    http.Response response;
    Map<String, String> data = {
      'serviceID': orderItemID,
    };
    String params = Uri(queryParameters: data).toString();
    var urlString =
        "https://njengapp.churchapp.co.ke/api/servicesByID" + params;
    response = await http.get(Uri.parse(urlString));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      return jsonResponse.map((service) => Service.fromJson(service)).toList();
    } else {
      return null;
    }
  }
}

Widget textRow(String textOne, String textTwo) {
  return Padding(
    padding: const EdgeInsets.only(right: 30.0),
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

