import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';

import '../models/customer.dart';
import '../utils/helpers.dart';
import 'customicon.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;

  CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: apiEndpoints.profileImage + customer.image,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                    placeholder: (context, url) => CircularProgressIndicator(
                      strokeWidth: 0,
                      color: Constants.secondaryColor,
                    ),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/images/blank.png"),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${customer.fname}  ${customer.lname}",
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      "Phone: ${customer.phone}",
                      style: TextStyle(
                        color: Constants.grayColor,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      "Orders: ${customer.ltvcount}",
                      style: TextStyle(
                        color: Constants.grayColor,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      "Amount: ${forCurrencyString(customer.ltvamount)}",
                      style: TextStyle(
                        color: Constants.grayColor,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      "Address: ${customer.address}",
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
                    // Text(
                    //   myDateFormat(alert.activityTime.toString()),
                    //   style: TextStyle(
                    //     color: Color.fromRGBO(19, 22, 33, 1),
                    //     fontSize: 15.0,
                    //   ),
                    //   textAlign: TextAlign.end,
                    // ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(child: MyCustomIcon(iconData: Icons.call, iconColor: Constants.whiteColor, containerColor: Constants.primaryColor),onTap: () {
                    makingPhoneCall(customer.phone);
                  }),
                  SizedBox(height: 15,),
                  GestureDetector(child: MyCustomIcon(iconData: FontAwesomeIcons.whatsapp, iconColor: Constants.whiteColor, containerColor: Constants.whatsAppGreenColor),onTap: () {
                    launchWhatsapp("254"+(customer.phone.replaceFirst("0", "")));
                  }),

                ],
              )
            ],
          ),
        ],
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
