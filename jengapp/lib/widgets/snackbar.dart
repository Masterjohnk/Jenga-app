import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jengapp/utils/constants.dart';

void showSnackBar(body, [title = "JengApp"]) {
  Get.snackbar(title, '',
      icon: Icon(
        Icons.info_outline_rounded,
        size: 30,
        color: Constants.whiteColor,
      ),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(10),
      backgroundColor: Constants.primaryColor,
      titleText: Text(
        title,
        style: TextStyle(fontSize: 18, color: Constants.whiteColor),
        textAlign: TextAlign.center,
      ),
      messageText: Text(body,
          style: TextStyle(fontSize: 16, color: Constants.whiteColor),
          textAlign: TextAlign.center),
      snackStyle: SnackStyle.FLOATING);
}
