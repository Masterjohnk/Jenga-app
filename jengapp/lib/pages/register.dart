import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';
import 'package:jengapp/widgets/app_button.dart';
import 'package:jengapp/widgets/input_widget.dart';

import '../utils/helpers.dart';
import '../widgets/dialogs.dart';
import '../widgets/snackbar.dart';

class Register extends StatelessWidget {
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController sNameController = TextEditingController();
  final TextEditingController piController = TextEditingController();
  final TextEditingController pi2Controller = TextEditingController();
  final TextEditingController piNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController IDController = TextEditingController();
  final TextEditingController countyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController memberIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Stack(
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
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 15.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Create Account",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height - 100.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Lets make a generic input widget
                              InputWidget(
                                prefixIcon: FontAwesomeIcons.user,
                                topLabel: "First name",
                                hintText: "Enter your first name",
                                textEditingController: fNameController,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InputWidget(
                                prefixIcon: FontAwesomeIcons.user,
                                topLabel: "Second name",
                                hintText: "Enter your second name",
                                textEditingController: sNameController,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InputWidget(
                                prefixIcon: FontAwesomeIcons.phone,
                                topLabel: "Phone number",
                                hintText: "Enter your phone number",
                                textEditingController: phController,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InputWidget(
                                prefixIcon: Icons.mail,
                                topLabel: "Email",
                                hintText: "Enter your email address",
                                textEditingController: emailController,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InputWidget2(
                                prefixIcon: FontAwesomeIcons.addressCard,
                                topLabel: "Delivery address",
                                                           hintText: "Enter your delivery address",
                                textEditingController: addressController,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InputWidget(
                                prefixIcon: FontAwesomeIcons.key,
                                topLabel: "Password",
                                obscureText: true,
                                hintText: "Enter your password",
                                textEditingController: piController,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InputWidget(
                                prefixIcon: FontAwesomeIcons.key,
                                topLabel: "Confirm password",
                                obscureText: true,
                                hintText: "Re-enter your password",
                                textEditingController: pi2Controller,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              AppButton(
                                  type: ButtonType.SECONDARY,
                                  text: "Register",
                                  onPressed: () {
                                    if (fNameController.text.isEmpty) {
                                      showSnackBar("Provide First Name");
                                      return;
                                    } else if (sNameController.text.isEmpty) {
                                      showSnackBar("Provide Second Name");
                                      return;
                                    } else if (!isEmail(
                                        emailController.text.trim())) {
                                      showSnackBar("Provide a valid email");
                                      return;
                                    } else if (addressController.text.isEmpty) {
                                      showSnackBar("Provide address");
                                      return;
                                    } else if (!validateMobile(
                                        phController.text)) {
                                      showSnackBar(
                                        "Provide a valid phone number. Do not include country code",
                                      );
                                      return;
                                    } else if (piController.text.isEmpty ||
                                        pi2Controller.text.isEmpty ||
                                        piController.text.compareTo(
                                                pi2Controller.text) !=
                                            0) {
                                      showSnackBar(
                                        "Provide two non-empty & matching PINs",
                                      );
                                      return;
                                    } else {
                                      signUp(
                                          fNameController.text,
                                          sNameController.text,
                                          emailController.text.trim(),
                                          phController.text,
                                          piController.text,
                                          memberIDController.text,
                                          IDController.text,
                                          addressController.text);
                                    }
                                  }),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signUp(String fname, String lname, String email, String phone, pass,
      String memberID, String IDNumber, String address) async {
    showProgressDialog("Registration", "Please wait as we register you");
    Map<String, String> data = {
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'email': email,
      'password': pass,
      'key': "mm",
      'memberID': memberID,
      'IDNumber': "",
      'county': "",
      'address': address,
    };
    var jsonResponse;

    await http
        .post(Uri.parse(apiEndpoints.register), body: data)
        .then((response) {
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        if (jsonResponse != null) {
          Get.back();
          int isRegistered = jsonResponse['code'];
          if (isRegistered == 0 || isRegistered == 3) {
            //success
            showModalDialog("Registration", jsonResponse['message']);
          }
          if (isRegistered == 1) {
            //success
            showSnackBar(
                "Registration", jsonResponse['message']);
            Get.offAllNamed('/dashboard');

          }
        }
      } else {
        Get.back();
        showModalDialog("Error",
            "Server is likely to be unavailable or overloaded. Report error code ${response.statusCode} to the system admin");
      }
    });
  }
}
