import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' as gett;
import 'package:get/get_core/src/get_main.dart';
//import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jengapp/controllers/profile-controller.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';
import 'package:path/path.dart';

import '../controllers/logincontroller.dart';
import '../models/profilemodel.dart';
import '../utils/helpers.dart';
import '../widgets/app_button.dart';
import '../widgets/dialogs.dart';
import '../widgets/input_widget.dart';
import '../widgets/snackbar.dart';

class Profile extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final LoginController loginController = Get.put(LoginController());
  Dio dio = Dio();

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  final TextEditingController piController = TextEditingController();
  final TextEditingController pi2Controller = TextEditingController();
  final TextEditingController piNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController IDController = TextEditingController();
  final TextEditingController countyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  //late File selectedImage;
  late Response response;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfileData().then((allProfiles) {
        profileController.updateAllProfiles(allProfiles);
        profileController.setProfilesNotLoading();
        populateProfileDetails();
      });
    });
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryColor,
      body: Stack(
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
                  SizedBox(
                    height: kToolbarHeight,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Profile",
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
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Constants.scaffoldBackgroundColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gett.Obx(
                          () => Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 2.0,
                                ),
                                profileController.profileLoading.value
                                    ? Center(
                                        child: Text("Loading profile data...",
                                            style: TextStyle(fontSize: 18)),
                                      )
                                    : profileController.profileList.length > 0
                                        ? Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Click on the pen to edit your account details",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                IconButton(
                                                  icon: Icon(profileController
                                                          .editDetails.value
                                                      ? Icons.edit_off
                                                      : Icons.edit),
                                                  color:
                                                      Constants.secondaryColor,
                                                  onPressed: () {
                                                    profileController
                                                        .updateEditDetails(
                                                            !profileController
                                                                .editDetails
                                                                .value);
                                                    populateProfileDetails();
                                                    //    snameController.text = members[index].lname;
                                                    // });
                                                  },
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20.0, 0.0, 20.0, 0.0),
                                              child: Column(children: [
                                                InputWidget(
                                                    enableText:
                                                        profileController
                                                            .editDetails.value,
                                                    prefixIcon:
                                                        FontAwesomeIcons.user,
                                                    topLabel: "First Name",
                                                    hintText:
                                                        "Enter first name",
                                                    textEditingController:
                                                        fnameController),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                InputWidget(
                                                    enableText:
                                                        profileController
                                                            .editDetails.value,
                                                    prefixIcon:
                                                        FontAwesomeIcons.user,
                                                    topLabel: "Last Name",
                                                    hintText: "Enter last name",
                                                    textEditingController:
                                                        lnameController),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                InputWidget(
                                                  enableText: profileController
                                                      .editDetails.value,
                                                  prefixIcon:
                                                      FontAwesomeIcons.phone,
                                                  topLabel: "Phone number",
                                                  hintText:
                                                      "Enter your phone number",
                                                  textEditingController:
                                                      phController,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                InputWidget(
                                                  enableText: profileController
                                                      .editDetails.value,
                                                  prefixIcon: Icons.mail,
                                                  topLabel: "Email",
                                                  hintText:
                                                      "Enter your email address",
                                                  textEditingController:
                                                      emailController,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                InputWidget2(
                                                  enableText: profileController
                                                      .editDetails.value,
                                                  prefixIcon: FontAwesomeIcons
                                                      .addressCard,
                                                  topLabel: "Delivery address",
                                                  hintText:
                                                      "Enter delivery address",
                                                  textEditingController:
                                                      addressController,
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                AppButton(
                                                    type: ButtonType.SECONDARY,
                                                    text:
                                                        "Update Profile Details",
                                                    onPressed: () {
                                                      if (fnameController
                                                          .text.isEmpty) {
                                                        showSnackBar(
                                                            "Provide First Name");
                                                        return;
                                                      } else if (lnameController
                                                          .text.isEmpty) {
                                                        showSnackBar(
                                                            "Provide Second Name");
                                                        return;
                                                      } else if (!isEmail(
                                                          emailController.text
                                                              .trim())) {
                                                        showSnackBar(
                                                            "Provide a valid email");
                                                        return;
                                                      } else if (!validateMobile(
                                                          phController.text)) {
                                                        showSnackBar(
                                                          "Provide a valid phone number. Do not include country code",
                                                        );
                                                        return;
                                                      } else {
                                                        updateUserDetails(
                                                            loginController
                                                                .customerID
                                                                .value,
                                                            fnameController
                                                                .text,
                                                            lnameController
                                                                .text,
                                                            emailController.text
                                                                .trim(),
                                                            phController.text,
                                                            addressController
                                                                .text);
                                                      }
                                                    }),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Click on the pen to update your password",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                          profileController
                                                                  .updatePassword
                                                                  .value
                                                              ? Icons.edit_off
                                                              : Icons.edit),
                                                      color: Constants
                                                          .secondaryColor,
                                                      onPressed: () {
                                                        profileController
                                                            .updateUserPassword(
                                                                !profileController
                                                                    .updatePassword
                                                                    .value);
                                                        //    snameController.text = members[index].lname;
                                                        // });
                                                      },
                                                    )
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                InputWidget(
                                                  enableText: profileController
                                                      .updatePassword
                                                      .value,
                                                  prefixIcon:
                                                      FontAwesomeIcons.key,
                                                  topLabel: "Password",
                                                  obscureText: true,
                                                  hintText:
                                                      "Enter your password",
                                                  textEditingController:
                                                      piController,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                InputWidget(
                                                  enableText: profileController
                                                      .updatePassword
                                                      .value,
                                                  prefixIcon:
                                                      FontAwesomeIcons.key,
                                                  topLabel: "Confirm password",
                                                  obscureText: true,
                                                  hintText:
                                                      "Re-enter your password",
                                                  textEditingController:
                                                      pi2Controller,
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                AppButton(
                                                    type: ButtonType.SECONDARY,
                                                    text: "Update Password",
                                                    onPressed: () {
                                                      if (piController
                                                              .text.isEmpty ||
                                                          pi2Controller
                                                              .text.isEmpty ||
                                                          piController.text
                                                                  .compareTo(
                                                                      pi2Controller
                                                                          .text) !=
                                                              0) {
                                                        showSnackBar(
                                                          "Provide two non-empty & matching PINs",
                                                        );
                                                        return;
                                                      } else {
                                                        updateUserPassword(
                                                            loginController
                                                                .customerID
                                                                .value,
                                                            piController.text);
                                                      }
                                                    }),

                                                //passwordupdate
                                              ]),
                                            )
                                          ])
                                        : Center(
                                            child: Text("No profile data",
                                                style: TextStyle(fontSize: 18)),
                                          )
                                // Let's create an order model
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<ProfileData>?> getProfileData() async {
    String url = apiEndpoints.getMemberProfile +
        "?customerID=" +
        loginController.customerID.value;
    http.Response response;
    response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((profileData) => ProfileData.fromJson(profileData))
          .toList();
    } else {
      return null;
    }
  }

  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    profileController.updateSelectedImage(File(image!.path));

    uploadImage();
  }

  uploadImage() async {
    print('upload image called');
    String uploadurl = apiEndpoints.updateMemberImage;

    FormData formdata = FormData.fromMap({
      "image": await MultipartFile.fromFile(
          File(profileController.selectedImage.value).path,
          filename: basename(File(profileController.selectedImage.value).path)
          //show only filename from path
          ),
      "customerID": loginController.customerID.value
    });
    dio.options.headers['contentType'] = "multipart/form-data";
    dio.options.headers['Content-Type'] = "application/json";
    response = await dio.post(
      uploadurl,
      data: formdata,
      options: Options(validateStatus: (status) => true),
      onSendProgress: (int sent, int total) {
        double percentage = ((sent / total) * 100);

        ///progress
        profileController
            .updateImageUploadLabel("${percentage.round()}% uploaded..");
        if (percentage.round() == 100) {
          profileController.updateImageUploadLabel("Update Image");
          getProfileData();
        }
      },
    );

    if (response.statusCode == 200) {
      profileController.updateImageUploadLabel("Update Image");
      getProfileData();
    } else {
      print(response.statusCode.toString());
      profileController.updateImageUploadLabel("Update Image");
      showModalDialog("Login", "Error updating image. Try later");
    }
  }

  updateUserDetails(String customerID, String fname, String lname, String email,
      String phone, String address) async {
    showProgressDialog("Profile", "Please wait as we update your profile");
    Map<String, String> data = {
      'customerID': customerID,
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'email': email,
      'address': address,
    };
    var jsonResponse;

    await http
        .post(Uri.parse(apiEndpoints.updateCustomerDetails), body: data)
        .then((response) {
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        if (jsonResponse != null) {
          Get.back();
          int isRegistered = jsonResponse['code'];
          if (isRegistered == 0 || isRegistered == 3) {
            //success
            showModalDialog("Profile", jsonResponse['message']);
          }
          if (isRegistered == 1) {
            //success
            showModalDialog("Profile", jsonResponse['message']);
          }
        }
      } else {
        Get.back();
        showModalDialog("Error",
            "Server is likely to be unavailable or overloaded. Report error code ${response.statusCode} to the system admin");
      }
    });
  }

  void populateProfileDetails() {
    fnameController.text = profileController.profileList[0].firstName;
    lnameController.text = profileController.profileList[0].secondName;
    phController.text = profileController.profileList[0].phone;
    emailController.text = profileController.profileList[0].email;
    addressController.text = profileController.profileList[0].address;
  }

  updateUserPassword(String customerID, String pass) async {
    showProgressDialog("Profile", "Please wait as we update your password");
    Map<String, String> data = {
      'customerID': customerID,
      'password': pass,
    };
    var jsonResponse;

    await http
        .post(Uri.parse(apiEndpoints.updateMemberPassword), body: data)
        .then((response) {
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        if (jsonResponse != null) {
          Get.back();
          int isRegistered = jsonResponse['code'];
          if (isRegistered == 0 || isRegistered == 3) {
            //success
            showModalDialog("Profile", jsonResponse['message']);
          }
          if (isRegistered == 1) {
            //success
            showModalDialog("Profile", jsonResponse['message']);
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
