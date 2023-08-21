import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jengapp/utils/constants.dart';
import 'package:jengapp/widgets/app_button.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    top: 100.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      height: 230.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/tools.jpg"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Image.asset(
                        "assets/images/logo.png",
                        scale: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      "Welcome to JengApp!",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Please sign in or create an account below to enjoy our services",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // Let's create a generic button widget
                    AppButton(
                      text: "Log in",
                      type: ButtonType.SECONDARY,
                      onPressed: () {
                        Get.toNamed("/login");
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    AppButton(
                      text: "Create an account",
                      type: ButtonType.SECONDARY,
                      onPressed: () {
                        Get.toNamed("/register");
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
