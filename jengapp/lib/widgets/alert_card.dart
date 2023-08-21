import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jengapp/utils/constants.dart';

import '../models/alert.dart';
import '../utils/helpers.dart';
import 'customicon.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;

  AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/order_details");
      },
      child: Container(
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
                getAlertIconWidget(alert.activityCategory),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.activityTitle,
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        alert.activityMessage,
                        style: TextStyle(
                          color: Constants.grayColor,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      // textRow("Service type", order.serviceType),
                      // SizedBox(
                      //   height: 5.0,
                      // ),
                      Text(
                        myDateFormat(alert.activityTime.toString()),
                        style: TextStyle(
                          color: Color.fromRGBO(19, 22, 33, 1),
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
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

Widget getAlertIconWidget(category) {
  switch (category) {
    case "System Message":
      return MyCustomIcon(
        iconData: FontAwesomeIcons.computer,
        iconColor: Constants.primaryColor,
        containerColor: Constants.primaryColorOpacity,
      );
    case "Order Message":
      return MyCustomIcon(
        iconData: FontAwesomeIcons.opencart,
        iconColor: Constants.secondaryColor,
        containerColor: Constants.secondaryColorOpacity,
      );
    case "Promotional Message":
      return MyCustomIcon(
        iconData: Icons.surround_sound,
        iconColor: Constants.primaryColor,
        containerColor: Constants.primaryColorOpacity,
      );
    case "Admin Message":
      return MyCustomIcon(
        iconData: Icons.admin_panel_settings_rounded,
        iconColor: Constants.primaryColor,
        containerColor: Constants.primaryColorOpacity,
      );
    default:
      return MyCustomIcon(
        iconData: FontAwesomeIcons.opencart,
        iconColor: Constants.primaryColor,
        containerColor: Constants.primaryColorOpacity,
      );
  }
}
