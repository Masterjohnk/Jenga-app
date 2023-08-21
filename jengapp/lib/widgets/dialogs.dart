import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

showProgressDialog(title, message) {
  return Get.defaultDialog(
    barrierDismissible: false,
    title: title,
    titleStyle: TextStyle(color: Constants.primaryColor),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            //value: 0.3,
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Constants.secondaryColor),
            //<-- SEE HERE
            // backgroundColor: Constants.secondaryColor, //<-- SEE HERE
          ),
        ),
      ],
    ),
  );
}

showModalDialog(title, message, [bool confirm = false]) {
  return Get.defaultDialog(
    title: title,
    barrierDismissible: false,
    middleText: message,
    middleTextStyle: TextStyle(fontSize: 16),
    backgroundColor: Constants.whiteColor,
    buttonColor: Constants.secondaryColor,
    titleStyle: TextStyle(color: Constants.primaryColor),
    radius: 10,
    textCancel: "Ok",
  );
}

showConfirmationModalDialog(
    title, message, confirmationMessage,cancelMessage, confirmationAction) {
  return Get.defaultDialog(
    title: title,
    barrierDismissible: false,
    middleText: message,
    buttonColor: Constants.secondaryColor,
    middleTextStyle: TextStyle(fontSize: 16),
    backgroundColor: Constants.whiteColor,
    titleStyle: TextStyle(color: Constants.primaryColor),
    radius: 10,
    textConfirm: confirmationMessage,
    onConfirm: confirmationAction,
    textCancel: cancelMessage
  );
}
