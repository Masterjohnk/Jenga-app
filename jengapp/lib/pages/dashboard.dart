import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jengapp/utils/api.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../controllers/cart-controller.dart';
import '../controllers/homescreen-controller.dart';
import '../controllers/logincontroller.dart';
import '../controllers/neworder-controller.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/promotion.dart';
import '../models/service.dart';
import '../utils/CartDBOperations.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/promotions_slider.dart';
import '../widgets/services_slider.dart';

class Dashboard extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final HomeScreenController dashController = Get.put(HomeScreenController());
  final OrderController orderController = Get.put(OrderController());
  final NewOrderController newOrderController = Get.put(NewOrderController());
  late final CartDBOperations myCart = CartDBOperations();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      getPromotions().then((promotions) {
        dashController.updatePromotionList(promotions);
      });
      getRecentOrders().then(
          (recentOrders) => dashController.updateRecentOrders(recentOrders));
      getServices().then((services) {
        dashController.updateServicesList(services);
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryColor,
       floatingActionButton: SpeedDial(
         child: Icon(Icons.phone_in_talk),
         closedForegroundColor: Colors.white,
         openForegroundColor: Colors.white,
         closedBackgroundColor: Constants.deepOrangeColor,
         openBackgroundColor: Constants.deepOrangeColor,
         labelsStyle: TextStyle(color: Constants.whiteColor),
         labelsBackgroundColor: Constants.primaryColor,
         //controller:
         speedDialChildren: <SpeedDialChild>[
           SpeedDialChild(
             child: Icon(Icons.call),
             foregroundColor: Constants.whiteColor,
             backgroundColor: Constants.secondaryColor,
             label: 'Call',
             onPressed: () {
               makingPhoneCall(Constants.phoneNumber);
             },
             closeSpeedDialOnPressed: false,
           ),
           SpeedDialChild(
             child: Icon(FontAwesomeIcons.whatsapp),
             foregroundColor: Constants.whiteColor,
             backgroundColor: Constants.whatsAppGreenColor,
             label: 'WhatsApp',
             onPressed: () {
               launchWhatsapp(Constants.phoneNumber);

             },
           ),
           //  Your other SpeedDialChildren go here.
         ],
       ),
       // floatingActionButton: FloatingActionButton(onPressed:(){
       //   makingPhoneCall('0714761654');
       // }, backgroundColor: Constants.secondaryColor,child: MyCustomIcon(iconData: Icons.call, iconColor: Constants.whiteColor,containerColor:Constants.secondaryColorOpacity)),
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
                      horizontal: 16.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showExitPopup();
                              },
                              child: Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 3,),
                            Text("Exit", style: TextStyle(fontSize: 16,color: Constants.secondaryColor),)
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: greeting() + "\n",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                      TextSpan(
                                        text: loginController.firstName.value+"\n",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      TextSpan(
                                        text: "Customer ID: "+loginController.customerID.value+"\n",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                          color: Colors.white,

                                        ),
                                      ),
                                      TextSpan(
                                        text: "Call us on: ${Constants.phoneNumber}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Constants.secondaryColor,

                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Column(
                              children: [
                                if (loginController.userRole
                                        .toString()
                                        .compareTo("1") ==
                                    0)
                                  myAdminButton("Admin", 10, 10, () {
                                    Get.toNamed('/admin-dashboard');
                                  }),
                                SizedBox(
                                  height: 5,
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.transparent,
                                  child: ClipOval(
                                    child: Obx(() => CachedNetworkImage(
                                          imageUrl: apiEndpoints.profileImage +
                                              dashController.profileImage.value,
                                          fit: BoxFit.cover,
                                          width: 200,
                                          height: 200,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(
                                            strokeWidth: 0,
                                            color: Constants.secondaryColor,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "assets/images/blank.png"),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          child: Text(
                            "Current Offers",
                            style: TextStyle(
                              color: Color.fromRGBO(19, 22, 33, 1),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 7.0),
                        Container(
                          height: ScreenUtil().setHeight(140.0),
                          child: Center(
                            // lets make a widget for the cards
                            child: PromotionsSlider(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          child: Text(
                            "Our Products",
                            style: TextStyle(
                              color: Color.fromRGBO(19, 22, 33, 1),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 7.0),
                        //ServicesSlider(),
                        Container(

                          child: Center(
                            // lets make a widget for the cards
                            child: ServicesSlider(),
                          ),
                        ),

                        // Obx(
                        //   () => Container(
                        //       child: dashController.recentOrderList.length > 0
                        //           ? Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 SizedBox(
                        //                   height: 20.0,
                        //                 ),
                        //                 Padding(
                        //                   padding: EdgeInsets.symmetric(
                        //                     horizontal: 24.0,
                        //                   ),
                        //                   child: Row(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.spaceBetween,
                        //                     children: [
                        //                       Text(
                        //                         "Latest Order",
                        //                         style: TextStyle(
                        //                           color: Color.fromRGBO(
                        //                               19, 22, 33, 1),
                        //                           fontSize: 18.0,
                        //                         ),
                        //                       ),
                        //                       GestureDetector(
                        //                         child: Text(
                        //                           "View All",
                        //                           style: TextStyle(
                        //                             color:
                        //                                 Constants.primaryColor,
                        //                             fontWeight: FontWeight.w600,
                        //                           ),
                        //                         ),
                        //                         onTap: () =>
                        //                             Get.toNamed('/all-orders'),
                        //                       )
                        //                     ],
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 10.0,
                        //                 ),
                        //                 ListView.separated(
                        //                   shrinkWrap: true,
                        //                   padding: EdgeInsets.symmetric(
                        //                     horizontal: 16.0,
                        //                     vertical: 10.0,
                        //                   ),
                        //                   physics:
                        //                       NeverScrollableScrollPhysics(),
                        //                   itemBuilder: (BuildContext context,
                        //                       int index) {
                        //                     // Lets pass the order to a new widget and render it there
                        //                     return OrderCard(
                        //                       order: dashController
                        //                           .recentOrderList[index],
                        //                     );
                        //                   },
                        //                   separatorBuilder:
                        //                       (BuildContext context,
                        //                           int index) {
                        //                     return SizedBox(
                        //                       height: 15.0,
                        //                     );
                        //                   },
                        //                   itemCount: dashController
                        //                       .recentOrderList.length,
                        //                 )
                        //
                        //                 // Let's create an order model
                        //               ],
                        //             )
                        //           : Center(
                        //               child: Text(
                        //               "No recent order..",
                        //               style: TextStyle(
                        //                   fontSize: 15,
                        //                   color: Constants.grayColor),
                        //             ))),
                        // ),
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
  Future<List<OrderItem>?> getAllOrders() async {
    var cartItemList = myCart.getCartItems();
    return cartItemList;
  }
  static Future<List<Service>?> getServices() async {
    String url = apiEndpoints.services;
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((service) => Service.fromJson(service)).toList();
    } else {
      return null;
    }
  }

  static Future<List<Promotion>?> getPromotions() async {
    String url = apiEndpoints.promotions;
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((promotion) => Promotion.fromJson(promotion))
          .toList();
    } else {
      return null;
    }
  }

  Future<List<Order>?> getRecentOrders() async {
    String url = apiEndpoints.allOrders +
        "?position=0&customerID=" +
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
