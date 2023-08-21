import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as mycal;

//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as mycal;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jengapp/models/client.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';

import '../controllers/logincontroller.dart';
import '../controllers/neworder-controller.dart';
import '../utils/CartDBOperations.dart';
import '../utils/helpers.dart';
import '../utils/prefs.dart';
import '../widgets/app_button.dart';
import '../widgets/dialogs.dart';
import '../widgets/input_widget.dart';
import '../widgets/sized_app_button.dart';
import '../widgets/snackbar.dart';

class OrderPlace extends StatelessWidget {
  final serviceData = Get.arguments;
  late final CartDBOperations myCart = CartDBOperations();
  final Prefs prefs = Prefs();
  final NewOrderController newOrderController = Get.put(NewOrderController());
  final LoginController loginController = Get.put(LoginController());
  late DateTime estimatedTime;
  final DateTime now = DateTime.now(); //lets say Jul 25 10:35:90
  final TextEditingController quantityTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    myCart.openDataBase();
    if (int.parse(serviceData[5]['duration'].toString()) == 1)
      estimatedTime = DateTime.now().add(new Duration(hours: 6));
    var closingTime = DateTime(now.year, now.month, now.day, 22, 0, 0, 0, 0);
    if (estimatedTime.compareTo(closingTime) < 0) {
    } else {
      estimatedTime =
          DateTime(now.year, now.month, now.day + 1, 08, 0, 0, 0, 0);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      prefs
          .getStringValuesSF("customerID")
          .then((ID) => loginController.updateCustomerID(ID));
      newOrderController.getTotalCost(serviceData[1]['cost']);
      getAllMembers().then((allClients) {
        newOrderController.updateClientList(allClients);
        //expenseController.setExpenseListNotLoading();
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryColor,
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/images/background.png",
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kToolbarHeight,
                    ),
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
                      height: 20.0,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "New Order\n",
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
                    SizedBox(
                      height: 5.0,
                    ),
                    Obx(
                      () => Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Constants.scaffoldBackgroundColor,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 16.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (loginController.userRole
                                            .toString()
                                            .compareTo("1") ==
                                        0)
                                      Obx(() => Checkbox(
                                          value: newOrderController
                                              .orderForClient.value,
                                          onChanged: (value) {
                                            newOrderController
                                                .updateOrderFOrClient(value);
                                          })),
                                    if (loginController.userRole
                                            .toString()
                                            .compareTo("1") ==
                                        0)
                                      Text("Order for a client",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Constants.secondaryColor)),
                                  ],
                                ),
                                if (newOrderController.orderForClient.value)
                                  Obx(() => DropdownButton<String>(
                                        // Step 3.
                                        value: newOrderController
                                            .selectedClientID.value,
                                        // Step 4.
                                        items: newOrderController.clientList
                                            .map<DropdownMenuItem<String>>(
                                                (Client value) {
                                          return DropdownMenuItem<String>(
                                            value: value.customerID,
                                            child: Text(
                                              value.firstName +
                                                  " " +
                                                  value.secondName,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      Constants.primaryColor),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        }).toList(),
                                        // Step 5.
                                        onChanged: (String? newValue) {
                                          newOrderController
                                              .updateSelectedClientID(
                                                  newValue!);
                                        },
                                      )),
                              ],
                            ),
                            CachedNetworkImage(
                              imageUrl: apiEndpoints.serviceImages +
                                  serviceData[2]['image'].toString(),
                              fit: BoxFit.cover,
                              //width: 200,
                              height: 200,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                strokeWidth: 0,
                                color: Constants.secondaryColor,
                              ),
                              errorWidget: (context, url, error) =>
                                  Image.asset("assets/images/blank.png"),
                            ),
                            Text(
                              "Order Details",
                              style: TextStyle(
                                color: Constants.secondaryColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  serviceData[0]['service']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "${forCurrencyString(serviceData[1]['cost'].toString().toUpperCase())}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Constants.primaryColor),
                                ),
                                Text(
                                  "/" +
                                      serviceData[4]['unit']
                                          .toString()
                                          .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Constants.primaryColor),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: [
                              serviceData[4]['unit']
                                          .toString()
                                          .toLowerCase()
                                          .compareTo("kg") ==
                                      0
                                  ? Text(
                                      "Number of Kgs (Approximately):",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Text(
                                      "Quantity",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              Spacer(),
                              Obx(
                                () => Row(
                                  children: [
                                    SizedInputWidget2(
                                      prefixIcon: FontAwesomeIcons.fonticons,
                                      textEditingController: newOrderController
                                          .quantityEditingController.value,
                                      newVal: (newOrderController
                                          .quantityEditingController
                                          .value
                                          .text),
                                      action: () {
                                        newOrderController.setUnits(
                                            newOrderController
                                                .quantityEditingController
                                                .value
                                                .text,
                                            serviceData[1]['cost']);
                                        newOrderController.getTotalCost(
                                            serviceData[1]['cost']);
                                        print('called');
                                      },
                                    ),

                                    // newOrderController.units != 0
                                  ],
                                ),
                              )
                            ]),
                            if (serviceData[4]['unit']
                                    .toString()
                                    .toLowerCase()
                                    .compareTo("kg") ==
                                0)
                              SizedBox(
                                height: 10,
                              ),
                            Divider(
                              height: 10,
                              thickness: 2,
                              color: Constants.grayColor,
                            ),
                            Obx(() => getSubtotalRow("Subtotal",
                                '${forCurrencyString(newOrderController.totalCost.value.toString())}')),
                            getSubtotalRow("Delivery fee", "\Kshs 0.00"),
                            SizedBox(
                              height: 10.0,
                            ),
                            Divider(
                              height: 10,
                              thickness: 2,
                              color: Constants.grayColor,
                            ),
                            Obx(() => getTotalRow("Total",
                                '${forCurrencyString(newOrderController.totalCost.value.toString())}')),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(() => Checkbox(
                                      value: newOrderController
                                          .isPickScheduled.value,
                                      onChanged: (value) {
                                        newOrderController
                                            .updateIsPickScheduled(value);
                                        if (value == true) {
                                          mycal.DatePicker.showDateTimePicker(
                                              context,
                                              minTime: DateTime.now(),
                                              maxTime: DateTime.now()
                                                  .add(new Duration(days: 30)),
                                              theme: mycal.DatePickerTheme(
                                                itemStyle: GoogleFonts.amaranth(
                                                    decorationColor: Constants
                                                        .primaryColorOpacity,
                                                    fontSize: 17),
                                                doneStyle: GoogleFonts.amaranth(
                                                    fontSize: 16),
                                                cancelStyle:
                                                    GoogleFonts.amaranth(
                                                        color:
                                                            Constants.grayColor,
                                                        fontSize: 16),
                                              ),
                                              showTitleActions: true,
                                              onChanged: (date) {
                                            newOrderController
                                                .updateScheduledDate(
                                                    date.toString());
                                            // // print('change $date in time zone ' +
                                            //      date.timeZoneOffset.inHours
                                            //          .toString());
                                          }, onCancel: () {
                                            newOrderController
                                                .isPickScheduled.value = false;
                                          }, onConfirm: (date) {
                                            newOrderController
                                                .updateScheduledDate(
                                                    date.toString());
                                            // print('confirm $date');
                                          },
                                              currentTime: DateTime.now(),
                                              locale: mycal.LocaleType.en);
                                        }
                                      })),
                                  Text("Schedule delivery date and time",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Constants.deepOrangeColor)),
                                  //if (newOrderController.schedulePickDate.value)
                                ],
                              ),
                            ),
                            if (newOrderController.isPickScheduled.value)
                              Row(
                                children: [
                                  Text(
                                    "Delivery time ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Constants.secondaryColor),
                                  ),
                                  Spacer(),
                                  Obx(
                                    () => Flexible(
                                      child: Text(
                                        myDateFormat(newOrderController
                                            .scheduledDate.value
                                            .toString()),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Constants.secondaryColor),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("*************")],
                            ),
                            if (serviceData[4]['unit']
                                    .toString()
                                    .toLowerCase()
                                    .compareTo("kg") ==
                                0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Actual cost will be computed once actual weight is determined.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      height: ScreenUtil().setHeight(127.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product Description",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Constants.secondaryColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    serviceData[3]['description'].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Estimated Delivery",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Constants.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    myDateFormat(estimatedTime.toString()),
                                    style: TextStyle(
                                      color: Color.fromRGBO(74, 77, 84, 1),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(37.0),
                                    height: ScreenUtil().setHeight(37.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Constants.primaryColor
                                          .withOpacity(.3),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.artstation,
                                      color: Constants.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    "Guaranteed quality",
                                    style: TextStyle(
                                      color: Color.fromRGBO(74, 77, 84, 1),
                                      fontSize: 12.0,
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
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          SizedAppButton(
                              type: SizedButtonType.SECONDARY,
                              text: "Add to cart & Check out",
                              onPressed: () async {
                                //createOrder(serviceData);

                                myCart.insertRecord(
                                    serviceID: serviceData[6]['serviceID'].toString(),
                                    serviceName: serviceData[0]['service']
                                        .toString()
                                        .toUpperCase(),
                                    serviceUnits: serviceData[4]['unit']
                                        .toString()
                                        .toLowerCase(),
                                    serviceImage: serviceData[2]['image'].toString(),
                                    approximateQuantity:
                                    newOrderController.units.toString(),
                                    amount: newOrderController.totalCost.toString(),
                                    isScheduledDate:
                                    newOrderController.isPickScheduled.value
                                        ? "1"
                                        : "0",
                                    scheduledDate:
                                    newOrderController.scheduledDate.value);
                                showSnackBar("Item added to cart");
                                Get.offAndToNamed('/my-cart');
                              }),
                          Spacer(),

                          SizedAppButton(
                              type: SizedButtonType.PLAIN,
                              text: "Add to cart & Shop more",
                              onPressed: () async {
                                                              myCart.insertRecord(
                                    serviceID: serviceData[6]['serviceID'].toString(),
                                    serviceName: serviceData[0]['service']
                                        .toString()
                                        .toUpperCase(),
                                    serviceUnits: serviceData[4]['unit']
                                        .toString()
                                        .toLowerCase(),
                                    serviceImage: serviceData[2]['image'].toString(),
                                    approximateQuantity:
                                    newOrderController.units.toString(),
                                    amount: newOrderController.totalCost.toString(),
                                    isScheduledDate:
                                    newOrderController.isPickScheduled.value
                                        ? "1"
                                        : "0",
                                    scheduledDate:
                                    newOrderController.scheduledDate.value);
                                showSnackBar("Item added to cart");
                                Get.offAndToNamed('/homescreen');

                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void createOrder(data) async {
  //   showProgressDialog("Ordering", "Please hold..");
  //
  //   var client = http.Client();
  //   await client.post(Uri.parse(apiEndpoints.createOrder), body: {
  //     "customerID": newOrderController.orderForClient.value
  //         ? newOrderController.selectedClientID.value
  //         : loginController.customerID.toString(),
  //     "serviceID": data[6]['serviceID'].toString(),
  //     "createdBy": loginController.customerID.toString(),
  //     "approximateQuantity": newOrderController.units.toString(),
  //     "amount": newOrderController.totalCost.toString(),
  //     "isPickScheduled": newOrderController.isPickScheduled.value ? "1" : "0",
  //     "scheduledPickDate": newOrderController.scheduledDate.value,
  //     "comments": "",
  //   }).then((response) {
  //     // print(response.body);
  //     Get.back();
  //     client.close();
  //     if (response.statusCode == 200) {
  //       var jsonResponse = json.decode(response.body);
  //       if (jsonResponse['code'] == 1 || jsonResponse['code'] == 0) {
  //         showConfirmationModalDialog(
  //             "Order", jsonResponse['message'], "Okay", "Cancel", () {
  //           newOrderController.updateIsPickScheduled(false);
  //           Get.toNamed('/homescreen');
  //         });
  //       }
  //     } else {
  //       serverError(response.statusCode.toString());
  //     }
  //   });
  // }
}

Widget getTotalRow(String title, String amount) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(19, 22, 33, 1),
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Text(
          amount,
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 17.0,
          ),
        )
      ],
    ),
  );
}

Future<List<Client>?> getAllMembers() async {
  String url = apiEndpoints.getAllMembers;
  http.Response response;
  response = await http.get(Uri.parse(url));
  //print(response.body);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => Client.fromJson(item)).toList();
  } else {
    return null;
  }
}

Widget getSubtotalRow(String title, String price) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Text(
          price,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
          ),
        )
      ],
    ),
  );
}

Widget getItemRow(String count, String item, String price) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          count,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            " x $item",
            style: TextStyle(
              color: Color.fromRGBO(143, 148, 162, 1),
              fontSize: 16.0,
            ),
          ),
        ),
        Text(
          price,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 16.0,
          ),
        )
      ],
    ),
  );
}
