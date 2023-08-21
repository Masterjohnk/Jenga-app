import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/dialogs.dart';
import '../widgets/snackbar.dart';
import 'constants.dart';

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

  return regExp.hasMatch(em);
}

bool validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning🌅,';
  }
  if (hour < 17) {
    return 'Good Afternoon☀️,';
  }
  return 'Good Evening😴,';
}

String myDateFormat(String date) {
  DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
  DateTime inputDate = DateTime.parse(parseDate.toString());
  String suffix = dateSuffix(inputDate);
  var outputFormat = DateFormat("E, dd'$suffix'-MMM-yy HH:mm a");
  return outputFormat.format(inputDate);
}

dateSuffix(DateTime date) {
  var suffix = "th";
  var digit = date.day % 10;
  if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
    suffix = ["st", "nd", "rd"][digit - 1];
  }
  return suffix;
}

String forCurrencyString(String num) {
  try {
    final formatCurrency = NumberFormat.currency(symbol: 'Kshs ');
    return formatCurrency.format(double.parse(num));
  } on FormatException {
    return "Kshs 0.00";
  }
}

void serverError(errorCode) {
  return showModalDialog(
      "Server Error",
      "Server is likely to be unavailable or overloaded. Report error code " +
          errorCode.toString() +
          " to the system admin");
}

makingPhoneCall(phone) async {
  var url = Uri.parse("tel:" + phone);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchWhatsappo(phone, [message = "Hi please pick my laundry at"]) async {
  var url = "https://wa.me/" + phone + "?text=" + Uri.encodeFull(message);
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

void launchWhatsapp(phone, [message = "Hi please pick my laundry at"]) async {
  var whatsappURlAndroid = "whatsapp://send?phone=" + phone + "&text=$message";
  var whatsappURLIos = "https://wa.me/$phone?text=${Uri.tryParse(message)}";
  if (Platform.isIOS) {
    // for iOS phone only
    if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
      await launchUrl(Uri.parse(
        whatsappURLIos,
      ));
    } else {
      showSnackBar("Whatsapp not installed");
    }
  } else {
    // android , web
    if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
      await launchUrl(Uri.parse(whatsappURlAndroid));
    } else {
      showSnackBar("Whatsapp not installed");
    }
  }
}

Widget myButton(
    String label, double height, double width, VoidCallback operation,
    [bool isVisible = true]) {
  return Visibility(
    visible: isVisible,
    child: ElevatedButton(
      onPressed: operation,
      style: ElevatedButton.styleFrom(
        primary: Constants.primaryColor,
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        label,
        //style: labelWhiteSmallerText().copyWith(fontSize: 18),
      ),
    ),
  );
}

Future<bool> showExitPopup() async {
  return await showConfirmationModalDialog(
      "Exit", "Do you want to exit JengApp?", "Exit", "Cancel", () {
    SystemNavigator.pop();
  });
}

Widget myAdminButton(
    String label, double height, double width, VoidCallback operation,
    [bool isVisible = true]) {
  return Visibility(
    visible: isVisible,
    child: ElevatedButton(
      onPressed: operation,
      style: ElevatedButton.styleFrom(
        primary: Constants.secondaryColor,
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        label,
        //style: labelWhiteSmallerText().copyWith(fontSize: 18),
      ),
    ),
  );
}
