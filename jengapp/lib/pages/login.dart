import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jengapp/controllers/logincontroller.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';
import 'package:jengapp/utils/helpers.dart';
import 'package:jengapp/widgets/app_button.dart';
import 'package:jengapp/widgets/dialogs.dart';
import 'package:jengapp/widgets/input_widget.dart';

import '../controllers/homescreen-controller.dart';
import '../models/loggedinuser.dart';
import '../utils/prefs.dart';
import '../widgets/snackbar.dart';

class Login extends StatelessWidget {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final Prefs _prefs = Prefs();
  final LoginController loginController = Get.put(LoginController());
  final HomeScreenController dashController = Get.put(HomeScreenController());
  //late FirebaseMessaging firebaseMessaging;
  late String customerID;
  bool initialised = false;

  @override
  Widget build(BuildContext context) {
    //firebaseMessaging = FirebaseMessaging.instance;
   // firebaseMessaging.getToken().then((value) {
      loginController.updateDeviceID("xx");
    //});
    _prefs.getBooleanValuesSF("remuser").then((rem) {
      if (rem && !initialised) {
        _prefs.getStringValuesSF("customerID").then((CID) {
          customerID = CID ?? '';
          emailTextEditingController.text = customerID;
        });
        initialised = true;
      }
      loginController.updateRememberPassword(rem);
      print(loginController.remPassword.value);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
                              "Log in to your account",
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
                                MediaQuery.of(context).size.height - 180.0,
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
                                topLabel: "Username",
                                hintText:
                                    "Enter phone number, email or customerID",
                                textEditingController:
                                    emailTextEditingController,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              InputWidget(
                                prefixIcon: FontAwesomeIcons.key,
                                topLabel: "Password",
                                obscureText: true,
                                hintText: "Enter your password",
                                textEditingController:
                                    passwordTextEditingController,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => Checkbox(
                                      activeColor: Constants.secondaryColor,
                                      value: loginController.remPassword.value,
                                      onChanged: (value) {
                                        loginController
                                            .updateRememberPassword(value);
                                        _prefs.addBooleanToSF(
                                            "remuser", value!);
                                      })),
                                  Text("Remember Me"),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (emailTextEditingController.text.isEmpty) {
                                    showSnackBar(
                                        "Provide username, you can use phone number, email or customerID");
                                    return;
                                  } else {
                                    showConfirmationModalDialog(
                                        "Password",
                                        "Initiate password recovery?",
                                        "Recover",
                                        "Cancel", () {
                                      showProgressDialog(
                                          "Recovering", "Please hold..");
                                      Get.back();
                                      var client = http.Client();
                                      client.post(
                                          Uri.parse(
                                              apiEndpoints.forGotPassword),
                                          body: {
                                            "customerID":
                                                emailTextEditingController.text,
                                          }).then((response) {
                                        client.close();

                                        if (response.statusCode == 200) {
                                          var jsonResponse =
                                              json.decode(response.body);
                                          if (jsonResponse['code'] == 1 ||
                                              jsonResponse['code'] == 0) {
                                            print(response.body);
                                            showModalDialog("Password recovery",
                                                jsonResponse['message']);
                                          }
                                        } else {
                                          serverError(
                                              response.statusCode.toString());
                                        }
                                      });
                                      Get.back();
                                    });
                                  }
                                },
                                child: Text(
                                  "Forgot Password?",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Constants.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),


                              SizedBox(
                                height: 20.0,
                              ),
                              AppButton(
                                type: ButtonType.SECONDARY,
                                text: "Log In",
                                onPressed: () {
                                  //Get.toNamed("/dashboard");
                                  if (emailTextEditingController.text.isEmpty) {
                                    showSnackBar(
                                        "Provide username, you can use phone number, email or customerID");
                                    return;
                                  } else if (passwordTextEditingController
                                      .text.isEmpty) {
                                    showSnackBar("Provide PIN");
                                    return;
                                  } else {
                                    signIn(emailTextEditingController.text,
                                        passwordTextEditingController.text);
                                    print(emailTextEditingController.text
                                        .toString());
                                  }
                                },
                              ),
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

  signIn(String memberID, pass) async {
    showProgressDialog("Logging in", "Hang in there");

    //DialogBuilder(context).showLoadingIndicator(
    // "Please wait as we authenticate you", "Authentication");
    Map<String, String> data = {
      'memberID': memberID,
      'password': pass,
      'key': loginController.deviceID.value,
    };
    String params = Uri(queryParameters: data).toString();
    var jsonResponse;
    await http.get(Uri.parse(apiEndpoints.login + params)).then((response) {
      Get.back();
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        if (jsonResponse != null) {
          // setState(() {
          //   DialogBuilder(context).hideOpenDialog();
          //});
          int isRegistered = jsonResponse['code'];
          if (isRegistered == 1) {
            var userDetails = jsonResponse['userdetails'];
            String userImage = userDetails['image'].toString();
            String fName = userDetails['fname'].toString();
            String lName = userDetails['lname'].toString();
            String userPhone = userDetails['phone'].toString();
            String userRole = userDetails['role'].toString();
            String customerID = userDetails['memberID'].toString();
            LoggedInUser loggedInUser = LoggedInUser(
                fName, lName, userPhone, userImage, userRole, customerID);
            loginController.updateUserDetails(fName);
            loginController.updateCustomerID(customerID);
            loginController.updateUserRole(userRole);

            dashController.updateProfileImage(userImage);
            //_prefs.addBooleanToSF("isRemember", isRememberMe);
            emailTextEditingController.text = "";
            passwordTextEditingController.text = "";
            _prefs.saveLoggedUser(loggedInUser);
            Get.toNamed('/homescreen');
          } else if (isRegistered == 0 ||
              isRegistered == 5 ||
              isRegistered == 10) {
            showModalDialog("Login", jsonResponse['message']);
          }
        }
      } else {
        serverError(response.statusCode);
      }
    });
  }
}
