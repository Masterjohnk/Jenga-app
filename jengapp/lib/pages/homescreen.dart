import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jengapp/pages/dashboard.dart';
//import 'package:jengapp/pages/dashboard2.dart';
import 'package:jengapp/pages/profile.dart';
import 'package:jengapp/pages/scheduledpickups.dart';
import 'package:jengapp/utils/constants.dart';

import '../controllers/cart-controller.dart';
import '../controllers/homescreen-controller.dart';
import '../controllers/logincontroller.dart';
import '../utils/CartDBOperations.dart';
import '../utils/helpers.dart';
import 'AllOrders.dart';
import 'alerts.dart';
import 'cart.dart';

class HomeScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final HomeScreenController homescreenController =
      Get.put(HomeScreenController());
  final OrderController orderController = Get.put(OrderController());

  final List pages = [
    Dashboard(),
    AllOrders(),
    SchedulePickups(),
    Alerts(),
    Cart(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homescreenController.updateMenuIndex(0);
    });

    return WillPopScope(
      onWillPop: () => showExitPopup(),
      child: Obx(() => Scaffold(
        resizeToAvoidBottomInset: false,
            bottomNavigationBar: CurvedNavigationBar(
              color: Constants.primaryColor,
              height: 60,
              backgroundColor: Constants.scaffoldBackgroundColor,
              buttonBackgroundColor: Constants.primaryColor,
              items: [
                Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.home,
                      size: 25.0,
                      color: Constants.whiteColor,
                      // color: homescreenController.menuIndex.value != 0
                      //     ? Colors.white
                      //     : Constants.primaryColor,
                    ),
                  ],
                ),
                Icon(
                  FontAwesomeIcons.listCheck,
                  size: 25.0,
                  color: Constants.whiteColor,
                ),
                Icon(

                  Icons.timelapse_outlined,
                  size: 30.0,
                  color: Constants.whiteColor,
                ),
                Icon(
                  Icons.notifications,
                  size: 30.0,
                  color: Constants.whiteColor,
                ),
                Obx(()=>Badge(
                  alignment: Alignment.topRight,
                  isLabelVisible: orderController.cartItemNumber>0?true:false,
                  backgroundColor: Constants.deepOrangeColor,
                  label: Text(orderController.cartItemNumber.value.toString(),style: TextStyle(fontSize: 10),),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 30.0,
                    color: Constants.whiteColor,
                  ),
                ),),

                Icon(
                  FontAwesomeIcons.user,
                  size: 25.0,
                  color: Constants.whiteColor,
                ),
              ],
              onTap: (index) {
                homescreenController.updateMenuIndex(index);
              },
            ),
            backgroundColor: Constants.primaryColor,
            body: pages[homescreenController.menuIndex.value],
          )),
    );
  }
}
